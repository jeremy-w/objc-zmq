#import <Foundation/Foundation.h>
#import <zmq.h>

#import "ZMQException.h"

@class ZMQContext;

typedef int ZMQSocketType;
typedef int ZMQSocketOption;
typedef int ZMQMessageSendFlags;
typedef int ZMQMessageReceiveFlags;

@interface ZMQSocket : NSObject

// Returns @"ZMQ_PUB" for ZMQ_PUB, for example.
+ (NSString *)nameForSocketType:(ZMQSocketType)type;

// Create a socket using -[ZMQContext socketWithType:].
@property(atomic, readonly, weak) ZMQContext *context;
@property(atomic, readonly, assign) ZMQSocketType type;

@property(readonly) void *socket;

- (id)init __attribute__((unavailable("use -[ZMQContext socketWithType:]")));

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

#pragma mark Subscribe
- (BOOL)subscribeAll;
- (BOOL)subscribe:(NSString *)prefix;

#pragma mark Polling
- (void)getPollItem:(zmq_pollitem_t *)outItem forEvents:(short)events;
@end
