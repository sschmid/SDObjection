//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "BindClassToProtocolSingletonModule.h"
#import "SomeObject.h"


@implementation BindClassToProtocolSingletonModule

- (void)configure:(JSObjectionInjector *)injector {
    [self bindClass:[SomeObject class] toProtocol:@protocol(SomeObjectProtocol) asSingleton:YES];
}

@end