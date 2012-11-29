//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "BindClassToClassModule.h"
#import "SomeObject.h"
#import "SomeOtherObject.h"


@implementation BindClassToClassModule

- (void)configure:(JSObjectionInjector *)injector {
    [self bindClass:[SomeObject class] toClass:[SomeOtherObject class] asSingleton:NO];
}


@end