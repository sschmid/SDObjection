//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "Objection.h"
#import "BindClassToProtocolModule.h"
#import "SomeObject.h"
#import "SomeDependency.h"


@implementation BindClassToProtocolModule

- (void)configure:(JSObjectionInjector *)injector {
    [self bindClass:[SomeObject class] toProtocol:@protocol(SomeObjectProtocol) asSingleton:NO];
}


@end