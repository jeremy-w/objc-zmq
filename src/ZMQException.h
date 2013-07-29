#import <Foundation/Foundation.h>

@interface ZMQException : NSException

-(id)initWithCode: (NSString *)aReason code:(int)errorCode;

@end
