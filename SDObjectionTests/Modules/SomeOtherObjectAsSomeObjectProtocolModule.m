#import "SomeOtherObjectAsSomeObjectProtocolModule.h"
#import "SomeObjectProtocol.h"
#import "SomeOtherObject.h"

@implementation SomeOtherObjectAsSomeObjectProtocolModule

- (void)configure {
    [self bindClass:[SomeOtherObject class] toProtocol:@protocol(SomeObjectProtocol) asSingleton:NO];
}

@end