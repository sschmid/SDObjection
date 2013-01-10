#import "SomeObjectAsSomeObjectProtocolModule.h"
#import "SomeObject.h"


@implementation SomeObjectAsSomeObjectProtocolModule

- (void)configure {
    [self bindClass:[SomeObject class] toProtocol:@protocol(SomeObjectProtocol) asSingleton:NO];
}

@end