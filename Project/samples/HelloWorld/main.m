//
//  main.m
//  HelloWorld
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
        //  Wait for next request from client
        NSData *data = [responder receiveDataWithFlags:0];
        
        //  Do some 'work'
		NSLog(@"do some work");
        sleep (1);
        
        //  Send reply back to client
        BOOL ok = [responder sendData:data withFlags:0];
		(void)ok;
    }
	
    [ctx terminate];
    return EXIT_SUCCESS;
}

int main(int argc, const char * argv[])
{
	(void)argc;
	(void)argv;
	
    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        
        return test();
        
    }
    return 0;
}

