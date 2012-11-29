//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "SomeModule.h"


@implementation SomeModule
@synthesize unloaded = _unloaded;
@synthesize injector = _injector;


- (void)configure:(JSObjectionInjector *)injector {
    self.unloaded = NO;
    self.injector = injector;
}

- (void)unload {
    self.unloaded = YES;
    self.injector = nil;
}


@end