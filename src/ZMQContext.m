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
		[(NSMutableArray *)self.sockets addObject:socket];
	}
	return socket;
}

@synthesize terminated;
- (void)terminate {
	(void)zmq_term(self.context);
	self.terminated = YES;
}
@end
