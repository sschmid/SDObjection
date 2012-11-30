//
// Created by sschmid on 26.11.12.
//
// contact@sschmid.com
//


#import "SomeDependencyModule.h"
#import "SomeDependency.h"


@implementation SomeDependencyModule

- (void)configure {
    [self bind:[[SomeDependency alloc] init] toClass:[SomeDependency class]];
}

@end