//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "SomeProvider.h"
#import "SomeObject.h"


@implementation SomeProvider
- (id)provide:(JSObjectionInjector *)context {
    return [[SomeObject alloc] init];
}
@end