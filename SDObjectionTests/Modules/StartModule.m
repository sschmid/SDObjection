//
// Created by sschmid on 05.12.12.
//
// contact@sschmid.com
//


#import "StartModule.h"
#import "SomeObject.h"


@implementation StartModule
@synthesize someObject = _someObject;


- (void)configure {
    [super configure];

    [self bind:[[SomeObject alloc] init] toClass:[SomeObject class]];
}

- (void)start {
    [super start];
    self.someObject = [self.injector getObject:[SomeObject class]];
}


@end