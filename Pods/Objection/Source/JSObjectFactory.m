#import "JSObjectFactory.h"

@interface JSObjectFactory ()
@property(nonatomic, readwrite, retain) JSObjectionInjector *injector;
@end

@implementation JSObjectFactory
@synthesize injector = _injector;

- (id)initWithInjector:(JSObjectionInjector *)injector {
    if ((self = [super init])) {
        self.injector = injector;
    }
    return self;
}

- (id)getObject:(id)classOrProtocol {
    return [self.injector getObject:classOrProtocol];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self getObject:key];
}

- (id)getObjectWithArgs:(id)classOrProtocol, ... {
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    id object = [self.injector getObject:classOrProtocol arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

- (void)dealloc {
    [_injector release];
    [super dealloc];
}

@end
