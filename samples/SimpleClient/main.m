//
//  main.m
//  SimpleClient
//
//  Derived from:
//  Hello World client in C++
//  http://zguide.zeromq.org/cpp:hwclient
//
//  Created by Simon Strandgaard on 10/26/12.
//  Copyright (c) 2012 Simon Strandgaard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQObjC.h"

int test() {
    
    ZMQContext *ctx = [[ZMQContext alloc] initWithIOThreads:1];
    
    NSString *endpoint = @"tcp://localhost:5555";
    ZMQSocket *requester = [ctx socketWithType:ZMQ_REQ];
    BOOL didConnect = [requester connectToEndpoint:endpoint];
    if (!didConnect) {
		NSLog(@"*** Failed to connect to endpoint [%@].", endpoint);
		return EXIT_FAILURE;
    }
	
    int kMaxRequest = 10;
	NSData *request = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
	for (int request_nbr = 0; request_nbr < kMaxRequest; ++request_nbr) {
        
        @autoreleasepool {
			
            NSLog(@"Sending request %d.", request_nbr);
            [requester sendData:request withFlags:0];
			
            NSLog(@"Waiting for reply");
            NSData *reply = [requester receiveDataWithFlags:0];
            NSString *text = [[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding];
            NSLog(@"Received reply %d: %@", request_nbr, text);
        }
        
	}
	
    
    
    [ctx terminate];
    return EXIT_SUCCESS;
}

int main(int argc, const char * argv[])
{
	(void)argc;
	(void)argv;
    
    @autoreleasepool {
        
        NSLog(@"Client is running");
        
        return test();
        
    }
    return 0;
}

