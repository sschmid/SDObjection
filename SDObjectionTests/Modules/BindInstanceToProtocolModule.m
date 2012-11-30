//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "BindInstanceToProtocolModule.h"
#import "SomeObjectProtocol.h"
#import "SomeObject.h"


@implementation BindInstanceToProtocolModule

- (void)configure {
    [self bind:[[SomeObject alloc] init] toProtocol:@protocol(SomeObjectProtocol)];
}


@end