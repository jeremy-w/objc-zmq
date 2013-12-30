//
//  main.m
//  SimpleServer
//
//  Derived from:
//  Hello World server in C++
//  http://zguide.zeromq.org/cpp:hwserver
//
//  Created by Simon Strandgaard on 10/26/12.
//  Copyright (c) 2012 Simon Strandgaard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQObjC.h"

int test() {
    
    ZMQContext *ctx = [[ZMQContext alloc] initWithIOThreads:1];
    
    NSString *endpoint = @"tcp://*:5555";
    ZMQSocket *responder = [ctx socketWithType:ZMQ_REP];
    BOOL didBind = [responder bindToEndpoint:endpoint];
    if (!didBind) {
		NSLog(@"*** Failed to bind to endpoint [%@].", endpoint);
		return EXIT_FAILURE;
    }
    
    while (1) {
        @autoreleasepool {
			
            //  Wait for next request from client
            NSData *data = [responder receiveDataWithFlags:0];
            NSString *text = [[NSString alloc]
                              initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Received request: %@", text);
            
            //  Do some 'work'
			NSLog(@"do some work");
            sleep (1);
            
            //  Send reply back to client
            NSString *world = @"World";
            NSData *reply = [world dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            BOOL ok = [responder sendData:reply withFlags:0];
            if (!ok) {
                NSLog(@"failed to reply");
            }
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
        
        NSLog(@"Server is running");
        
        return test();
        
    }
    return 0;
}

