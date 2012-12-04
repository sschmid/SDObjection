#import "JSObjection.h"

static JSObjectionInjector *gGlobalInjector;

@implementation JSObjection

+ (JSObjectionInjector *)createInjector {
    return [[[JSObjectionInjector alloc] init] autorelease];
}

+ (void)setDefaultInjector:(JSObjectionInjector *)anInjector {
    if (gGlobalInjector != anInjector) {
        [gGlobalInjector release];
        gGlobalInjector = [anInjector retain];
    }
}

+ (JSObjectionInjector *)defaultInjector {
    return [[gGlobalInjector retain] autorelease];
}

@end
