#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectFactory.h"
#import "JSObjectionUtils.h"
#import "Objection.h"

@interface __JSObjectionInjectorDefaultModule : JSObjectionModule
@end

@implementation __JSObjectionInjectorDefaultModule

- (void)configure {
    [self bind:[[[JSObjectFactory alloc] initWithInjector:self.injector] autorelease] toClass:[JSObjectFactory class]];
}

@end

@interface JSObjectionInjector (Private)
- (void)initializeEagerSingletons;
- (void)configureDefaultModule;
- (void)configureModule:(JSObjectionModule *)module;
@end

@implementation JSObjectionInjector

- (id)init {
    if ((self = [super init])) {
        _context = [[NSMutableDictionary alloc] init];
        _modules = [[NSMutableDictionary alloc] init];
        _eagerSingletons = [[NSMutableSet alloc] init];
        [self configureDefaultModule];
    }

    return self;
}

- (id)getObjectWithArgs:(id)classOrProtocol, ... {
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    id object = [self getObject:classOrProtocol arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

- (id)objectForKeyedSubscript:(id)key {
    return [self getObjectWithArgs:key, nil];
}

- (id)getObject:(id)classOrProtocol {
    return [self getObjectWithArgs:classOrProtocol, nil];
}

- (id)getObject:(id)classOrProtocol arguments:(va_list)argList {
    @synchronized (self) {
        if (!classOrProtocol)
            return nil;

        NSString *key = nil;
        if (class_isMetaClass(object_getClass(classOrProtocol)))
            key = NSStringFromClass(classOrProtocol);
        else
            key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];

        id <JSObjectionEntry> injectorEntry = [_context objectForKey:key];
        injectorEntry.injector = self;

        if (classOrProtocol && injectorEntry) {
            NSArray *arguments = JSObjectionUtils.transformVariadicArgsToArray(argList);
            if ([injectorEntry isKindOfClass:[JSObjectionInjectorEntry class]]) {
                id object = [injectorEntry extractObject:arguments];
                [self injectIntoObject:object];
                return object;
            } else {
                return [injectorEntry extractObject:arguments];
            }

        }

        return nil;
    }

    return nil;

}

- (void)injectIntoObject:(id)object {
    if ([[object class] respondsToSelector:@selector(objectionRequires)]) {
        NSArray *properties = [[object class] performSelector:@selector(objectionRequires)];
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];

        for (NSString *propertyName in properties) {
            objc_property_t property = JSObjectionUtils.propertyForClass([object class], propertyName);
            JSObjectionPropertyInfo propertyInfo = JSObjectionUtils.findClassOrProtocolForProperty(property);
            id desiredClassOrProtocol = propertyInfo.value;
            // Ensure that the class is initialized before attempting to retrieve it.
            // Using +load would force all registered classes to be initialized so we are
            // lazily initializing them.
            if (propertyInfo.type == JSObjectionTypeClass)
                [desiredClassOrProtocol class];

            id dependency = [self getObject:desiredClassOrProtocol];

            if (dependency == nil && propertyInfo.type == JSObjectionTypeClass) {
                JSObjectionModule *module = [[JSObjectionModule alloc] init];
                [module bindClass:desiredClassOrProtocol toClass:desiredClassOrProtocol asSingleton:NO];
                [self addModule:module];

                dependency = [self getObject:desiredClassOrProtocol];

                [self removeModuleInstance:module];
                [module release];
            } else if (!dependency) {
                @throw [NSException exceptionWithName:@"JSObjectionException"
                                               reason:[NSString stringWithFormat:@"Cannot find an instance that is bound to the protocol '%@' to assign to the property '%@'", NSStringFromProtocol(desiredClassOrProtocol), propertyName]
                                             userInfo:nil];
            }

            [propertiesDictionary setObject:dependency forKey:propertyName];
        }

        [object setValuesForKeysWithDictionary:propertiesDictionary];

        if ([object respondsToSelector:@selector(awakeFromObjection)]) {
            [object performSelector:@selector(awakeFromObjection)];
        }
    }
}

- (void)addModule:(JSObjectionModule *)module {
    [self addModule:module withName:NSStringFromClass([module class])];
}

- (void)addModules:(NSArray *)modules {
    for (JSObjectionModule *module in modules) {
        [self registerModule:module name:NSStringFromClass([module class])];
        [self configureModule:module];
    }
    [self initializeEagerSingletons];
}

- (void)addModule:(JSObjectionModule *)module withName:(NSString *)name {
    [self registerModule:module name:name];
    [self configureModule:module];
    [self initializeEagerSingletons];
}

- (void)removeModuleInstance:(JSObjectionModule *)module {
    JSObjectionModule *existingModule;
    NSMutableDictionary *modules = [_modules copy];
    for (NSString *moduleKey in modules) {
        existingModule = [_modules objectForKey:moduleKey];
        if (existingModule == module) {
            [self destroyModule:existingModule withKey:moduleKey];
            break;
        }
    }
    [modules release];
}

- (void)removeModuleClass:(Class)aClass {
    [self removeModuleWithName:NSStringFromClass(aClass)];
}

- (void)removeModuleWithName:(NSString *)name {
    JSObjectionModule *module = [_modules objectForKey:name];
    if (module)
        [self destroyModule:module withKey:name];
}

- (void)removeAllModules {
    for (NSString *moduleKey in [_modules allKeys])
        [self removeModuleWithName:moduleKey];
}

- (BOOL)hasModuleClass:(Class)aClass {
    return [self hasModuleWithName:NSStringFromClass(aClass)];
}

- (BOOL)hasModuleWithName:(NSString *)name {
    return [_modules objectForKey:name] != nil;
}

- (void)dealloc {
    [_context release];
    [_eagerSingletons release];
    [_modules release];
    [super dealloc];
}

#pragma mark - Private

- (void)initializeEagerSingletons {
    for (NSString *eagerSingletonKey in _eagerSingletons) {
        id entry = [_context objectForKey:eagerSingletonKey];
        if ([entry lifeCycle] == JSObjectionInstantiationRuleSingleton) {
            [self getObject:NSClassFromString(eagerSingletonKey)];
        } else {
            @throw [NSException exceptionWithName:@"JSObjectionException"
                                           reason:[NSString stringWithFormat:@"Unable to initialize eager singleton for the class '%@' because it was never registered as a singleton", eagerSingletonKey]
                                         userInfo:nil];
        }
    }
}

- (void)configureModule:(JSObjectionModule *)module {
    module.injector = self;
    [module configure];
    for (NSString *singleton in module.eagerSingletons)
        [_eagerSingletons addObject:singleton];
    [_context addEntriesFromDictionary:module.bindings];
    [module start];
}

- (void)configureDefaultModule {
    __JSObjectionInjectorDefaultModule *module = [[__JSObjectionInjectorDefaultModule alloc] init];
    [self addModule:module];
    [module release];
}

- (void)registerModule:(JSObjectionModule *)module name:(NSString *)name {
    if (![_modules objectForKey:name])
        [_modules setObject:module forKey:name];
}

- (void)unConfigureModule:(JSObjectionModule *)module {
    for (NSString *bindingKey in module.bindings) {
        [_context removeObjectForKey:bindingKey];
    }

    for (NSString *singleton in module.eagerSingletons)
        [_eagerSingletons removeObject:singleton];
}

- (void)destroyModule:(JSObjectionModule *)module withKey:(NSString *)key {
    [module unload];
    [self unConfigureModule:module];
    [_modules removeObjectForKey:key];
}

- (void)dumpContext {
    NSLog(@"Context of Injector: %@", self);
    JSObjectionModule *module;
    for (NSString *moduleKey in _modules) {
        module = [_modules objectForKey:moduleKey];
        for (NSString *bindingKey in module.bindings)
            NSLog(@"- %@ : %@", bindingKey, [module.bindings objectForKey:bindingKey]);
    }
}

@end
