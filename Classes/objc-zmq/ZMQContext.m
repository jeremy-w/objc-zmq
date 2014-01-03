#import "ZMQContext.h"

@interface ZMQSocket (ZMQContextIsFriend)
- (id)initWithContext:(ZMQContext *)context type:(ZMQSocketType)type;
@end

@interface ZMQContext () {
	OSSpinLock socketsLock;
}

@property(atomic, assign) void *context;
@property(readwrite, getter=isTerminated, NS_NONATOMIC_IPHONEONLY)
	BOOL terminated;

@property(atomic, strong) NSMutableSet *sockets;

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

	self.context = zmq_init(threadCount);
	if (!self.context) {
		NSLog(@"%s: *** Error creating ZMQContext: zmq_init: %s",
		      __func__, zmq_strerror(zmq_errno()));
        @throw [[ZMQException alloc] initWithCode:[[NSString alloc]
                                                   initWithUTF8String:zmq_strerror(zmq_errno())] 
                                             code:zmq_errno()];
	}

	socketsLock = OS_SPINLOCK_INIT;
	self.sockets = [NSMutableSet new];
	return self;
}

- (void)dealloc {
	[self terminate];
}

- (ZMQSocket *)socketWithType:(ZMQSocketType)type {
	ZMQSocket *	socket = [[ZMQSocket alloc] initWithContext:self type:type];
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

- (void)terminate {
	(void)zmq_term(self.context);
	self.context = NULL;
	self.terminated = YES;
}
@end
