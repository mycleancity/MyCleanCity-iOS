//
//  JSONValueTransformer+NSDate.m
//  CupSub
//
//  Created by fliptoo on 10/4/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import "JSONValueTransformer+NSDate.h"
#import "Constant.h"

@implementation JSONValueTransformer (NSDate)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    return [formatter stringFromDate:date];
}

@end
