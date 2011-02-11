#import "ZMQContext.h"

@interface ZMQSocket (ZMQContextIsFriend)
- (id)initWithContext:(ZMQContext *)context type:(ZMQSocketType)type;
@end

@interface ZMQContext ()
@property(readonly) void *context;
@property(readwrite, getter=isTerminated, NS_NONATOMIC_IPHONEONLY)
	BOOL terminated;
@end

@implementation ZMQContext
+ (void)getZMQVersionMajor:(int *)major minor:(int *)minor patch:(int *)patch {
	(void)zmq_version(major, minor, patch);
}

#pragma mark Polling
+ (int)pollWithItems:(zmq_pollitem_t *)ioItems count:(int)itemCount
		timeoutAfterUsec:(long)usec {
	int ret = zmq_poll(ioItems, itemCount, usec);
	return ret;
}

- (id)initWithIOThreads:(NSUInteger)threadCount {
	self = [super init];
	if (!self) return nil;

	context = zmq_init(threadCount);
	if (!context) {
		NSLog(@"%s: *** Error creating ZMQContext: zmq_init: %s",
		      __func__, zmq_strerror(zmq_errno()));
		[self release];
		return nil;
	}

	socketsLock = OS_SPINLOCK_INIT;
	sockets = [[NSMutableArray alloc] init];
	return self;
}

@synthesize context;
- (void)dealloc {
	[self terminate];
	context = NULL;
	[sockets release], sockets = nil;
	[super dealloc];
}

@synthesize sockets;
- (ZMQSocket *)socketWithType:(ZMQSocketType)type {
	ZMQSocket *
	socket = [[[ZMQSocket alloc] initWithContext:self type:type] autorelease];
	if (socket) {
		OSSpinLockLock(&socketsLock); {
			[(NSMutableArray *)self.sockets addObject:socket];
		} OSSpinLockUnlock(&socketsLock);
	}
	return socket;
}

- (void)closeSockets {
	for (ZMQSocket *socket in self.sockets) {
		[socket close];
	}
}

@synthesize terminated;
- (void)terminate {
	(void)zmq_term(self.context);
	self.terminated = YES;
}
@end
