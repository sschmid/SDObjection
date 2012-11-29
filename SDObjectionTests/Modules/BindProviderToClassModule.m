//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "BindProviderToClassModule.h"
#import "SomeObject.h"
#import "SomeProvider.h"


@implementation BindProviderToClassModule

- (void)configure:(JSObjectionInjector *)injector {
    [self bindProvider:[[SomeProvider alloc] init] toClass:[SomeObject class]];
}


@end