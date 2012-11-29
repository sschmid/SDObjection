//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import "Objection.h"
#import "SomeObject.h"

@implementation SomeObject

objection_requires(@"dep")
@synthesize dep = _dep;
@synthesize awake = _awake;

- (void)awakeFromObjection {
    self.awake = YES;
}

@end