//
// Created by sschmid on 28.11.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "Objection.h"
#import "SomeModule.h"
#import "BindInstanceToClassModule.h"
#import "SomeObject.h"
#import "SomeOtherObject.h"
#import "BindInstanceToProtocolModule.h"
#import "BindClassToProtocolModule.h"
#import "SomeDependency.h"
#import "BindClassToProtocolSingletonModule.h"
#import "BindProviderToClassModule.h"
#import "BindClassToClassModule.h"
#import "BindProviderToProtocolModule.h"
#import "BindBlockToProtocolModule.h"
#import "BindBlockToClassModule.h"
#import "RegisterEagerSingletonModule.h"
#import "RegisterSingletonModule.h"
#import "StartModule.h"
#import "SomeDependencyModule.h"

SPEC_BEGIN(SDObjectionSpec)

        describe(@"SDObjection", ^{

            __block JSObjectionInjector *injector = nil;
            beforeEach(^{
                injector = [JSObjection createInjector];

            });

            context(@"general usage", ^{

                it(@"creates an injector", ^{
                    [injector shouldNotBeNil];
                    [[injector should] beKindOfClass:[JSObjectionInjector class]];
                });

                it(@"returns nothing", ^{
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldBeNil];
                });

                it(@"does not have any modules", ^{
                    BOOL has = [injector hasModuleClass:[SomeModule class]];

                    [[theValue(has) should] beNo];
                });

                it(@"has no module with name", ^{
                    BOOL has = [injector hasModuleWithName:@"theModule"];

                    [[theValue(has) should] beNo];
                });

                it(@"creates an injector with module", ^{
                    [injector addModule:[[SomeModule alloc] init]];

                    [injector shouldNotBeNil];
                    [[injector should] beKindOfClass:[JSObjectionInjector class]];
                });

                it(@"creates an injector with module and name", ^{
                    [injector addModule:[[SomeModule alloc] init] withName:@"theModule"];

                    [injector shouldNotBeNil];
                    [[injector should] beKindOfClass:[JSObjectionInjector class]];
                });

                it(@"has a module", ^{
                    [injector addModule:[[SomeModule alloc] init]];
                    BOOL has = [injector hasModuleClass:[SomeModule class]];

                    [[theValue(has) should] beYes];
                });

                it(@"has a module with name", ^{
                    [injector addModule:[[SomeModule alloc] init] withName:@"theModule"];
                    BOOL has = [injector hasModuleWithName:@"theModule"];

                    [[theValue(has) should] beYes];
                });

                it(@"has module with injector", ^{
                    SomeModule *someModule = [[SomeModule alloc] init];
                    [injector addModule:someModule];
                    BOOL has = someModule.injector != nil;

                    [[theValue(has) should] beYes];
                });

                it(@"has no module, when removed", ^{
                    [injector addModule:[[SomeModule alloc] init]];
                    [injector removeModuleClass:[SomeModule class]];
                    BOOL has = [injector hasModuleClass:[SomeModule class]];

                    [[theValue(has) should] beNo];
                });

                it(@"has no module with name, when removed", ^{
                    NSString *name = @"theModule";
                    [injector addModule:[[SomeModule alloc] init] withName:name];
                    [injector removeModuleWithName:name];
                    BOOL has = [injector hasModuleWithName:name];

                    [[theValue(has) should] beNo];
                });

                it(@"removes module instance", ^{
                    NSString *name = @"theModule";
                    SomeModule *aModule = [[SomeModule alloc] init];
                    [injector addModule:aModule withName:name];
                    [injector removeModuleInstance:aModule];
                    BOOL hasName = [injector hasModuleWithName:name];
                    BOOL hasClass = [injector hasModuleClass:[SomeModule class]];

                    [[theValue(hasName) should] beNo];
                    [[theValue(hasClass) should] beNo];
                });
                
                it(@"has no module with injector", ^{
                    SomeModule *someModule = [[SomeModule alloc] init];
                    [injector addModule:someModule];
                    [injector removeModuleClass:[someModule class]];
                    BOOL has = someModule.injector != nil;

                    [[theValue(has) should] beNo];
                });

                it(@"starts module with its bindings ready", ^{
                    StartModule *startModule = [[StartModule alloc] init];
                    [injector addModule:startModule];

                    [startModule.someObject shouldNotBeNil];
                    [[startModule.someObject should] beKindOfClass:[SomeObject class]];
                });

                it(@"module is not unloaded", ^{
                    SomeModule *someModule = [[SomeModule alloc] init];
                    [injector addModule:someModule];

                    [[theValue(someModule.unloaded) should] beNo];
                });

                it(@"module is unloaded", ^{
                    SomeModule *someModule = [[SomeModule alloc] init];
                    [injector addModule:someModule];
                    [injector removeModuleClass:[someModule class]];

                    [[theValue(someModule.unloaded) should] beYes];
                });

                it(@"has all modules", ^{
                    NSArray *modules = [NSArray arrayWithObjects:[[BindInstanceToProtocolModule alloc] init], [[SomeModule alloc] init], nil];
                    [injector addModules:modules];

                    BOOL has1 = [injector hasModuleClass:[BindInstanceToProtocolModule class]];
                    BOOL has2 = [injector hasModuleClass:[SomeModule class]];

                    [[theValue(has1) should] beYes];
                    [[theValue(has2) should] beYes];
                });

                it(@"removes modules", ^{
                    NSArray *modules = [NSArray arrayWithObjects:[[RegisterEagerSingletonModule alloc] init], [[SomeModule alloc] init], nil];
                    [injector addModules:modules];

                    [injector removeAllModules];

                    BOOL has1 = [injector hasModuleClass:[RegisterEagerSingletonModule class]];
                    BOOL has2 = [injector hasModuleClass:[SomeModule class]];

                    [[theValue(has1) should] beNo];
                    [[theValue(has2) should] beNo];
                });

                it(@"has no bindings", ^{
                    JSObjectionModule *module = [[JSObjectionModule alloc] init];

                    [[module.bindings should] beEmpty];
                    [[module.eagerSingletons should] beEmpty];
                });

                it(@"has bindings", ^{
                    JSObjectionModule *module = [[JSObjectionModule alloc] init];
                    [module bind:[[SomeObject alloc] init] toClass:[SomeObject class]];
                    [module registerEagerSingleton:[SomeOtherObject class]];

                    [[module.bindings shouldNot] beEmpty];
                    [[module.eagerSingletons shouldNot] beEmpty];
                });

                it(@"has no bindings, when removed", ^{
                    JSObjectionModule *module = [[JSObjectionModule alloc] init];
                    [module bind:[[SomeObject alloc] init] toClass:[SomeObject class]];
                    [module registerEagerSingleton:[SomeOtherObject class]];
                    [module reset];

                    [[module.bindings should] beEmpty];
                    [[module.eagerSingletons should] beEmpty];
                });

                it(@"can retrieve objects from context in module.unload", ^{
                    SomeModule *module = [[SomeModule alloc] init];
                    [injector addModule:module];
                    [injector removeModuleClass:[module class]];
                    BOOL has = module.unloadObj != nil;

                    [[theValue(has) should] beYes];

                });

                it(@"injects dependencies into existing object", ^{
                    JSObjectionModule *testModule = [[JSObjectionModule alloc] init];
                    [testModule registerSingleton:[SomeDependency class]];
                    [injector addModule:testModule];

                    SomeObject *someObject1 = [[SomeObject alloc] init];
                    SomeObject *someObject2 = [[SomeObject alloc] init];

                    [injector injectIntoObject:someObject1];
                    [injector injectIntoObject:someObject2];

                    [someObject1.dep shouldNotBeNil];
                    [[someObject1.dep should] beKindOfClass:[SomeDependency class]];

                    [someObject2.dep shouldNotBeNil];
                    [[someObject2.dep should] beKindOfClass:[SomeDependency class]];

                    [[someObject1.dep should] equal:someObject2.dep];
                });

            });

            context(@"when bind instance to class", ^{

                beforeEach(^{
                    [injector addModule:[[BindInstanceToClassModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldNotBeNil];
                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"returns always same instance", ^{
                    id o1 = [injector getObject:[SomeObject class]];
                    id o2 = [injector getObject:[SomeObject class]];

                    [[o1 should] equal:o2];
                });

                it(@"does not have dependencies set", ^{
                    SomeObject *o = [injector getObject:[SomeObject class]];

                    [o.dep shouldBeNil];
                    [[theValue(o.awake) should] beNo];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindInstanceToClassModule class]];
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldBeNil];
                });

            });

            context(@"when bind instance to protocol", ^{

                beforeEach(^{
                    [injector addModule:[[BindInstanceToProtocolModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o shouldNotBeNil];
                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always return same instance", ^{
                    id o1 = [injector getObject:@protocol(SomeObjectProtocol)];
                    id o2 = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o1 should] equal:o2];
                });

                it(@"does not have dependencies set", ^{
                    SomeObject *o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o.dep shouldBeNil];
                    [[theValue(o.awake) should] beNo];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindInstanceToProtocolModule class]];
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o shouldBeNil];
                });

            });

            context(@"when bind class to protocol", ^{

                beforeEach(^{
                    [injector addModule:[[BindClassToProtocolModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns different instances", ^{
                    id o1 = [injector getObject:@protocol(SomeObjectProtocol)];
                    id o2 = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o1 shouldNot] equal:o2];
                });

                it(@"does have dependencies set", ^{
                    SomeObject *o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o.dep should] beKindOfClass:[SomeDependency class]];
                    [[theValue(o.awake) should] beYes];
                });

                it(@"has different dependencies set", ^{
                    SomeObject *o1 = [injector getObject:@protocol(SomeObjectProtocol)];
                    SomeObject *o2 = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o1.dep shouldNot] equal:o2.dep];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindClassToProtocolModule class]];
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o shouldBeNil];
                });

            });

            context(@"when bind class to protocol (singleton)", ^{

                beforeEach(^{
                    [injector addModule:[[BindClassToProtocolSingletonModule alloc] init]];
                });

                it(@"always returns same instance", ^{
                    SomeObject *o1 = [injector getObject:@protocol(SomeObjectProtocol)];
                    SomeObject *o2 = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o1 should] equal:o2];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindClassToProtocolSingletonModule class]];
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o shouldBeNil];
                });

            });

            context(@"when bind class to class", ^{

                beforeEach(^{
                    [injector addModule:[[BindClassToClassModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:[SomeOtherObject class]];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns different instances", ^{
                    id o1 = [injector getObject:[SomeOtherObject class]];
                    id o2 = [injector getObject:[SomeOtherObject class]];

                    [[o1 shouldNot] equal:o2];
                });

                it(@"has dependencies set", ^{
                    SomeObject *o = [injector getObject:[SomeOtherObject class]];

                    [[o.dep should] beKindOfClass:[SomeDependency class]];
                    [[theValue(o.awake) should] beYes];
                });

                it(@"has different dependencies set", ^{
                    SomeObject *o1 = [injector getObject:[SomeOtherObject class]];
                    SomeObject *o2 = [injector getObject:[SomeOtherObject class]];

                    [[o1.dep shouldNot] equal:o2.dep];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindClassToClassModule class]];
                    id o = [injector getObject:[SomeOtherObject class]];

                    [o shouldBeNil];
                });

            });

            context(@"when bind provider to class", ^{

                beforeEach(^{
                    [injector addModule:[[BindProviderToClassModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:[SomeObject class]];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns different instance", ^{
                    id o1 = [injector getObject:[SomeObject class]];
                    id o2 = [injector getObject:[SomeObject class]];

                    [[o1 shouldNot] equal:o2];
                });

                it(@"returns no instance", ^{
                    [injector removeModuleClass:[BindProviderToClassModule class]];
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldBeNil];
                });

            });

            context(@"when bind provider to protocol", ^{

                beforeEach(^{
                    [injector addModule:[[BindProviderToProtocolModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns different instance", ^{
                    id o1 = [injector getObject:@protocol(SomeObjectProtocol)];
                    id o2 = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o1 shouldNot] equal:o2];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindProviderToProtocolModule class]];
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o shouldBeNil];
                });

            });

            context(@"when bind block to protocol", ^{

                beforeEach(^{
                    [injector addModule:[[BindBlockToProtocolModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns different instance", ^{
                    id o1 = [injector getObject:@protocol(SomeObjectProtocol)];
                    id o2 = [injector getObject:@protocol(SomeObjectProtocol)];

                    [[o1 shouldNot] equal:o2];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindBlockToProtocolModule class]];
                    id o = [injector getObject:@protocol(SomeObjectProtocol)];

                    [o shouldBeNil];
                });

            });

            context(@"when bind block to class", ^{

                beforeEach(^{
                    [injector addModule:[[BindBlockToClassModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:[SomeObject class]];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns different instance", ^{
                    id o1 = [injector getObject:[SomeObject class]];
                    id o2 = [injector getObject:[SomeObject class]];

                    [[o1 shouldNot] equal:o2];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[BindBlockToClassModule class]];
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldBeNil];
                });
            });

            context(@"when register singleton", ^{

                beforeEach(^{
                    [injector addModule:[[RegisterSingletonModule alloc] init]];
                });

                it(@"returns instance", ^{
                    id o = [injector getObject:[SomeObject class]];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns same instance", ^{
                    id o1 = [injector getObject:[SomeObject class]];
                    id o2 = [injector getObject:[SomeObject class]];

                    [[o1 should] equal:o2];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[RegisterSingletonModule class]];
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldBeNil];
                });

            });

            context(@"when registerEagerSingleton", ^{

                beforeEach(^{
                    [injector addModule:[[RegisterEagerSingletonModule alloc] init]];
                });

                it(@"returns instance", ^{
                    SomeObject *o = [injector getObject:[SomeObject class]];

                    [[o should] beKindOfClass:[SomeObject class]];
                });

                it(@"always returns same instance", ^{
                    SomeObject *o1 = [injector getObject:[SomeObject class]];
                    SomeObject *o2 = [injector getObject:[SomeObject class]];

                    [[o1 should] equal:o2];
                });

                it(@"has dependencies set", ^{
                    SomeObject *o = [injector getObject:[SomeObject class]];

                    [[o.dep should] beKindOfClass:[SomeDependency class]];
                    [[theValue(o.awake) should] beYes];
                });

                it(@"returns no instance, when removed", ^{
                    [injector removeModuleClass:[RegisterEagerSingletonModule class]];
                    id o = [injector getObject:[SomeObject class]];

                    [o shouldBeNil];
                });
            });
        });


        SPEC_END