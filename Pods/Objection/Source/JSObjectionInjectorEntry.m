#import "JSObjectionInjectorEntry.h"
#import "JSObjectionUtils.h"

@interface JSObjectionInjectorEntry ()
- (id)buildObject:(NSArray *)arguments;
- (id)argumentsForObject:(NSArray *)givenArguments;
- (SEL)initializerForObject;
@end

@implementation JSObjectionInjectorEntry
@synthesize lifeCycle = _lifeCycle;
@synthesize classEntry = _classEntry;


#pragma mark Instance Methods

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle {
    if ((self = [super init])) {
        _lifeCycle = theLifeCycle;
        _classEntry = theClass;
        _storageCache = nil;
    }

    return self;
}

- (id)extractObject:(NSArray *)arguments {
    if (self.lifeCycle == JSObjectionInstantiationRuleNormal || !_storageCache) {
        return [self buildObject:arguments];
    }

    return _storageCache;
}

- (void)dealloc {
    [_storageCache release];
    _storageCache = nil;
    [super dealloc];
}


#pragma mark Private Methods

- (id)buildObject:(NSArray *)arguments {
    id object = nil;

    if ([self.classEntry respondsToSelector:@selector(objectionInitializer)])
        object = JSObjectionUtils.buildObjectWithInitializer(self.classEntry, [self initializerForObject], [self argumentsForObject:arguments]);
    else
        object = [[[self.classEntry alloc] init] autorelease];

    if (self.lifeCycle == JSObjectionInstantiationRuleSingleton)
        _storageCache = [object retain];

    return object;
}

- (SEL)initializerForObject {
    return NSSelectorFromString([[self.classEntry performSelector:@selector(objectionInitializer)] objectForKey:JSObjectionInitializerKey]);
}

- (NSArray *)argumentsForObject:(NSArray *)givenArguments {
    return givenArguments.count > 0 ? givenArguments : [[self.classEntry performSelector:@selector(objectionInitializer)] objectForKey:JSObjectionDefaultArgumentsKey];
}

#pragma mark Class Methods

+ (id)entryWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle {
    return [[[JSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle] autorelease];
}

+ (id)entryWithEntry:(JSObjectionInjectorEntry *)entry {
    return [[[JSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle] autorelease];
}
@end
