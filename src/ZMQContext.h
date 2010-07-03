#import <Foundation/Foundation.h>
#import "ZMQSocket.h"  // ZMQSocketType

@interface ZMQContext : NSObject {
	void *context;
	NSMutableArray *sockets;
	BOOL terminated;
}
+ (void)getZMQVersionMajor:(int *)major minor:(int *)minor patch:(int *)patch;

// Creates a ZMQContext using |threadCount| threads for I/O.
- (id)initWithIOThreads:(NSUInteger)threadCount;

- (ZMQSocket *)socketWithType:(ZMQSocketType)type;
// Sockets associated with this context.
@property(readonly, retain, NS_NONATOMIC_IPHONEONLY) NSArray *sockets;

// Initiates termination. All associated sockets will be shut down.
- (void)terminate;

// YES if termination has been initiated.
// KVOable.
@property(readonly, getter=isTerminated, NS_NONATOMIC_IPHONEONLY)
	BOOL terminated;
@end
