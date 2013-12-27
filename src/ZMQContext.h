#import <Foundation/Foundation.h>
#import "ZMQSocket.h"  // ZMQSocketType
#import "ZMQException.h"
#import <libkern/OSAtomic.h>

/* Special polling timeout values. */
#define ZMQPollTimeoutNever (-1)
#define ZMQPollTimeoutNow   (0)

@interface ZMQContext : NSObject

+ (void)getZMQVersionMajor:(int *)major minor:(int *)minor patch:(int *)patch;

/* Polling */
// Generic poll interface.
+ (int)pollWithItems:(zmq_pollitem_t *)ioItems count:(int)itemCount
		timeoutAfterUsec:(long)usec;

// Creates a ZMQContext using |threadCount| threads for I/O.
- (id)initWithIOThreads:(NSUInteger)threadCount;

- (ZMQSocket *)socketWithType:(ZMQSocketType)type;
// Sockets associated with this context.
@property(atomic, strong, readonly) NSSet *sockets;

// Closes all associated sockets.
- (void)closeSockets;

// Initiates termination. All associated sockets will be shut down.
- (void)terminate;

// YES if termination has been initiated.
// KVOable.
@property(readonly, getter=isTerminated, NS_NONATOMIC_IPHONEONLY)
	BOOL terminated;
@end
