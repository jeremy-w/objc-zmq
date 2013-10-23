#import <Foundation/Foundation.h>
#import <zmq.h>
@class ZMQContext;

typedef int ZMQSocketType;
typedef int ZMQSocketOption;
typedef int ZMQMessageSendFlags;
typedef int ZMQMessageReceiveFlags;

@interface ZMQSocket : NSObject {
	void *socket;
	ZMQContext *context;  // not retained
	NSString *endpoint;
	ZMQSocketType type;
	BOOL closed;
}
// Returns @"ZMQ_PUB" for ZMQ_PUB, for example.
+ (NSString *)nameForSocketType:(ZMQSocketType)type;

// Create a socket using -[ZMQContext socketWithType:].
@property(readonly, assign, NS_NONATOMIC_IPHONEONLY) ZMQContext *context;
@property(readonly, NS_NONATOMIC_IPHONEONLY) ZMQSocketType type;

- (void)close;
// KVOable.
@property(readonly, getter=isClosed, NS_NONATOMIC_IPHONEONLY) BOOL closed;
@property(readonly, copy, NS_NONATOMIC_IPHONEONLY) NSString *endpoint;

#pragma mark Socket Options
- (BOOL)setData:(NSData *)data forOption:(ZMQSocketOption)option;
- (NSData *)dataForOption:(ZMQSocketOption)option;

#pragma mark Endpoint Configuration
- (BOOL)bindToEndpoint:(NSString *)endpoint;
- (BOOL)connectToEndpoint:(NSString *)endpoint;

#pragma mark Communication
- (BOOL)sendData:(NSData *)messageData withFlags:(ZMQMessageSendFlags)flags;
- (NSData *)receiveDataWithFlags:(ZMQMessageReceiveFlags)flags;

- (int)receiveWithBuffer:(void *)buffer
         withBufferLength:(NSInteger)length
                withFlags:(ZMQMessageReceiveFlags)flags;

#pragma mark Polling
- (void)getPollItem:(zmq_pollitem_t *)outItem forEvents:(short)events;
@end
