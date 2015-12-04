//
//  NSDate+JQTimeAgo.h
//  InstaB Cloud
//
//  Created by fliptoo on 12/5/13.
//  Copyright (c) 2013 fong huang yee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JQTimeAgo)

- (NSString*)timeAgo;

@end

extern NSString* const kJQTimeAgoAllowFutureKey;
extern NSString* const kJQTimeAgoStringsPrefixAgoKey;
extern NSString* const kJQTimeAgoStringsPrefixFromNowKey;
extern NSString* const kJQTimeAgoStringsSuffixAgoKey;
extern NSString* const kJQTimeAgoStringsSuffixFromNowKey;
extern NSString* const kJQTimeAgoStringsSecondsKey;
extern NSString* const kJQTimeAgoStringsMinuteKey;
extern NSString* const kJQTimeAgoStringsMinutesKey;
extern NSString* const kJQTimeAgoStringsHourKey;
extern NSString* const kJQTimeAgoStringsHoursKey;
extern NSString* const kJQTimeAgoStringsDayKey;
extern NSString* const kJQTimeAgoStringsDaysKey;
extern NSString* const kJQTimeAgoStringsMonthKey;
extern NSString* const kJQTimeAgoStringsMonthsKey;
extern NSString* const kJQTimeAgoStringsYearKey;
extern NSString* const kJQTimeAgoStringsYearsKey;
extern NSString* const kJQTimeAgoStringsNumbersKey;
