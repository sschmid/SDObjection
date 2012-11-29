//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "Objection.h"
#import "BindBlockToProtocolModule.h"
#import "SomeObjectProtocol.h"
#import "SomeObject.h"


@implementation BindBlockToProtocolModule

- (void)configure:(JSObjectionInjector *)injector {

    id (^block)(JSObjectionInjector *) = ^id(JSObjectionInjector *inj) {
        return [[SomeObject alloc] init];
    };

    [self bindBlock:block toProtocol:@protocol(SomeObjectProtocol)];
}


@end