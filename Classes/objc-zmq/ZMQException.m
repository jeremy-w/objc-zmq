#import "ZMQException.h"

@implementation ZMQException

- (id)initWithCode:(NSString *)aReason code:(int)errorCode
{
    self = [[ZMQException alloc] initWithName:@"ZMQException" 
                                       reason:aReason 
                                     userInfo:@{@"errorCode": @(errorCode)}];

    return self;
}

@end
