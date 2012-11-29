//
// Created by sschmid on 28.11.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"

SPEC_BEGIN(SDObjectionSpec)

        describe(@"SDObjection", ^{

            it(@"fails", ^{
                [[[NSObject alloc] init] shouldBeNil];
            });

        });

        SPEC_END