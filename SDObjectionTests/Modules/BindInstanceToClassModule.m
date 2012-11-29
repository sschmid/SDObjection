//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "BindInstanceToClassModule.h"
#import "SomeObject.h"


@implementation BindInstanceToClassModule

- (void)configure:(JSObjectionInjector *)injector {
    [self bind:[[SomeObject alloc] init] toClass:[SomeObject class]];
}


@end