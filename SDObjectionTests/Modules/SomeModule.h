//
// Created by sschmid on 23.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "Objection.h"


@interface SomeModule : JSObjectionModule
@property(nonatomic) BOOL unloaded;
@property(nonatomic, strong) id unloadObj;
@end