//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "Objection.h"
#import "RegisterEagerSingletonModule.h"
#import "SomeObject.h"


@implementation RegisterEagerSingletonModule

- (void)configure:(JSObjectionInjector *)injector {
    [self registerEagerSingleton:[SomeObject class]];
}


@end