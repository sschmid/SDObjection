//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SomeObjectProtocol.h"

@class SomeDependency;

@interface SomeObject : NSObject <SomeObjectProtocol>
@property(nonatomic, strong) SomeDependency *dep;
@property(nonatomic) BOOL awake;
@end