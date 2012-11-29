//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "Objection.h"
#import "BindBlockToClassModule.h"
#import "SomeObject.h"


@implementation BindBlockToClassModule

- (void)configure:(JSObjectionInjector *)injector {

    id (^block)(JSObjectionInjector *) = ^id(JSObjectionInjector *inj) {
        return [[SomeObject alloc] init];
    };

    [self bindBlock:block toClass:[SomeObject class]];
}


@end