#import <Foundation/Foundation.h>
#import "JSObjectionInjector.h"

@interface JSObjectFactory : NSObject

@property(nonatomic, readonly) JSObjectionInjector *injector;

- (id)initWithInjector:(JSObjectionInjector *)injector;
- (id)getObject:(id)classOrProtocol;
- (id)objectForKeyedSubscript:(id)key;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;

@end
