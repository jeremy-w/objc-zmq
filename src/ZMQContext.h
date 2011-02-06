#import <Foundation/Foundation.h>
#import "ZMQSocket.h"  // ZMQSocketType
#import <libkern/OSAtomic.h>

/* Special polling timeout values. */
#define ZMQPollTimeoutNever (-1)
#define ZMQPollTimeoutNow   (0)

@interface ZMQContext : NSObject {
	void *context;
	NSMutableArray *sockets;
	OSSpinLock socketsLock;
	BOOL terminated;
}
+ (void)getZMQVersionMajor:(int *)major minor:(int *)minor patch:(int *)patch;

/* Polling */
// Generic poll interface.
+ (int)pollWithItems:(zmq_pollitem_t *)ioItems count:(int)itemCount
		timeoutAfterUsec:(long)usec;

// Creates a ZMQContext using |threadCount| threads for I/O.
- (id)initWithIOThreads:(NSUInteger)threadCount;

- (ZMQSocket *)socketWithType:(ZMQSocketType)type;
// Sockets associated with this context.
@property(readonly, retain, NS_NONATOMIC_IPHONEONLY) NSArray *sockets;

// Closes all associated sockets.
- (void)closeSockets;

// Initiates termination. All associated sockets will be shut down.
- (void)terminate;

// YES if termination has been initiated.
// KVOable.
@property(readonly, getter=isTerminated, NS_NONATOMIC_IPHONEONLY)
	BOOL terminated;
@end
