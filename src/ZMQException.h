//
//  ZMQException.h
//  zmqobjc
//
//  Created by Massimo Gengarelli on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMQException : NSException {
    @private int _error_code;
}

-(id)initWithCode: (NSString *)aReason code:(int)errorCode;
-(void) setErrorCode:(int) error_code;
-(int) getErrorCode;

@end
