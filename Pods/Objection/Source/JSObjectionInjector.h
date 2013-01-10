#import <Foundation/Foundation.h>
#import "JSObjectionModule.h"

@interface JSObjectionInjector : NSObject {
    NSMutableDictionary *_context;
    NSMutableSet *_eagerSingletons;
    NSMutableDictionary *_modules;
}


@property (nonatomic, strong)JSObjectionInjector * parentInjector;

- (id)getObject:(id)classOrProtocol;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (id)getObject:(id)classOrProtocol arguments:(va_list)argList;
- (id)objectForKeyedSubscript:(id)key;

- (void)injectIntoObject:(id)object;

- (void)addModule:(JSObjectionModule *)module;
- (void)addModules:(NSArray *)modules;
- (void)addModule:(JSObjectionModule *)module withName:(NSString *)name;

- (void)removeModuleInstance:(JSObjectionModule *)module;
- (void)removeModuleClass:(Class)aClass;
- (void)removeModuleWithName:(NSString *)name;
- (void)removeAllModules;

- (BOOL)hasModuleClass:(Class)aClass;
- (BOOL)hasModuleWithName:(NSString *)name;

- (void)dumpContext;

- (JSObjectionInjector *)createChildInjector;
@end
