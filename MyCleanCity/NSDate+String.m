//
//  NSDate+String.m
//  CincaiBuy
//
//  Created by fliptoo on 1/21/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "NSDate+String.h"
#import "Constant.h"

@implementation NSDate (String)

- (NSString *)asString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:86400]];
    return [formatter stringFromDate:self];
}

@end
