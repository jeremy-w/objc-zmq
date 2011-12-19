//
//  ZMQException.m
//  zmqobjc
//
//  Created by Massimo Gengarelli on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZMQException.h"

@implementation ZMQException

- (int)getErrorCode
{
    return _error_code;
}

- (void)setErrorCode:(int)error_code
{
    _error_code = error_code;
}

- (id)initWithCode:(NSString *)aReason code:(int)errorCode
{
    self = [[ZMQException alloc] initWithName:@"ZMQException" 
                                       reason:aReason 
                                     userInfo:nil];
    _error_code = errorCode;
    
    return self;
}

@end
