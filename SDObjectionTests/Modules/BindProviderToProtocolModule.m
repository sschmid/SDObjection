//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "BindProviderToProtocolModule.h"
#import "SomeObjectProtocol.h"
#import "SomeProvider.h"


@implementation BindProviderToProtocolModule

- (void)configure:(JSObjectionInjector *)injector {
    [self bindProvider:[[SomeProvider alloc] init] toProtocol:@protocol(SomeObjectProtocol)];
}


@end