#import <Foundation/Foundation.h>

@interface ZMQException : NSException {
    @private int _error_code;
}

-(id)initWithCode: (NSString *)aReason code:(int)errorCode;
-(void) setErrorCode:(int) error_code;
-(int) getErrorCode;

@end
