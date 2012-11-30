//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "SomeModule.h"


@implementation SomeModule
@synthesize unloaded = _unloaded;
@synthesize unloadObj = _unloadObj;


- (void)configure {
    self.unloaded = NO;
    [self bindClass:[NSObject class] toClass:[NSObject class] asSingleton:NO];
}

- (void)unload {
    self.unloadObj = [self.injector getObject:[NSObject class]];
    self.unloaded = YES;
    [super unload];
}


@end