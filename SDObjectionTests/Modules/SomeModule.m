//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "SomeModule.h"


@implementation SomeModule
@synthesize unloaded = _unloaded;


- (void)configure {
    self.unloaded = NO;
}

- (void)unload {
    self.unloaded = YES;
    [super unload];
}


@end