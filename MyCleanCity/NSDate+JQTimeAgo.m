//
//  NSDate+JQTimeAgo.m
//  InstaB Cloud
//
//  Created by fliptoo on 12/5/13.
//  Copyright (c) 2013 fong huang yee. All rights reserved.
//

#import "NSDate+JQTimeAgo.h"

@implementation NSDate (JQTimeAgo)

- (NSString*)timeAgo
{
    NSTimeInterval distanceMillis = -1000.0 * [self timeIntervalSinceNow];
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSString* prefix = [defs stringForKey: kJQTimeAgoStringsPrefixAgoKey];
    NSString* suffix = [defs stringForKey: kJQTimeAgoStringsSuffixAgoKey];
    if ([defs boolForKey: kJQTimeAgoAllowFutureKey])
    {
        if (distanceMillis < 0.0)
        {
            prefix = [defs stringForKey: kJQTimeAgoStringsPrefixFromNowKey];
            suffix = [defs stringForKey: kJQTimeAgoStringsSuffixFromNowKey];
        }
        distanceMillis = fabs(distanceMillis);
    }
    
    const double seconds = distanceMillis / 1000.0;
    const double minutes = seconds / 60.0;
    const double hours = minutes / 60.0;
    const double days = hours / 24.0;
    const double years = days / 365.0;
    
    NSString* words = nil;
    if (seconds < 45)
        words = [[defs stringForKey: kJQTimeAgoStringsSecondsKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)round(seconds)]];
    else if (seconds < 90)
        words = [[defs stringForKey: kJQTimeAgoStringsMinuteKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)1]];
    else if (minutes < 45)
        words = [[defs stringForKey: kJQTimeAgoStringsMinutesKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)round(minutes)]];
    else if (minutes < 90)
        words = [[defs stringForKey: kJQTimeAgoStringsHourKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)1]];
    else if (hours < 24)
        words = [[defs stringForKey: kJQTimeAgoStringsHoursKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)round(hours)]];
    else if (hours < 48)
        words = [[defs stringForKey: kJQTimeAgoStringsDayKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)1]];
    else if (days < 30)
        words = [[defs stringForKey: kJQTimeAgoStringsDaysKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)floor(days)]];
    else if (days < 60)
        words = [[defs stringForKey: kJQTimeAgoStringsMonthKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)1]];
    else if (days < 365)
        words = [[defs stringForKey: kJQTimeAgoStringsMonthsKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)floor(days/30.0)]];
    else if (years < 2)
        words = [[defs stringForKey: kJQTimeAgoStringsYearKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)1]];
    else
        words = [[defs stringForKey: kJQTimeAgoStringsYearsKey] stringByReplacingOccurrencesOfString: @"%d" withString: [NSString stringWithFormat: @"%d", (int)floor(years)]];
    
    NSString* retVal = [[NSString stringWithFormat: @"%@ %@ %@",
                         (prefix ? prefix : @""),
                         (words ? words : @""),
                         (suffix ? suffix : @"")] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return retVal;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool: NO], kJQTimeAgoAllowFutureKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsPrefixAgoKey, nil, [NSBundle mainBundle], @" ", @"kJQTimeAgoStringsPrefixAgoKey"), kJQTimeAgoStringsPrefixAgoKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsPrefixFromNowKey, nil, [NSBundle mainBundle], @" ", @"kJQTimeAgoStringsPrefixFromNowKey"), kJQTimeAgoStringsPrefixFromNowKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsSuffixAgoKey, nil, [NSBundle mainBundle], @" ", @"kJQTimeAgoStringsSuffixAgoKey"), kJQTimeAgoStringsSuffixAgoKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsSuffixFromNowKey, nil, [NSBundle mainBundle], @"from now", @"kJQTimeAgoStringsSuffixFromNowKey"), kJQTimeAgoStringsSuffixFromNowKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsSecondsKey, nil, [NSBundle mainBundle], @"1 min ago", @"kJQTimeAgoStringsSecondsKey"), kJQTimeAgoStringsSecondsKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsMinuteKey, nil, [NSBundle mainBundle], @"1 min ago", @"kJQTimeAgoStringsMinuteKey"), kJQTimeAgoStringsMinuteKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsMinutesKey, nil, [NSBundle mainBundle], @"%d mins ago", @"kJQTimeAgoStringsMinutesKey"), kJQTimeAgoStringsMinutesKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsHourKey, nil, [NSBundle mainBundle], @"1 hour ago", @"kJQTimeAgoStringsHourKey"), kJQTimeAgoStringsHourKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsHoursKey, nil, [NSBundle mainBundle], @"%d hours ago", @"kJQTimeAgoStringsHoursKey"), kJQTimeAgoStringsHoursKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsDayKey, nil, [NSBundle mainBundle], @"1 day ago", @"kJQTimeAgoStringsDayKey"), kJQTimeAgoStringsDayKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsDaysKey, nil, [NSBundle mainBundle], @"%d days ago", @"kJQTimeAgoStringsDaysKey"), kJQTimeAgoStringsDaysKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsMonthKey, nil, [NSBundle mainBundle], @"1m ago", @"kJQTimeAgoStringsMonthKey"), kJQTimeAgoStringsMonthKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsMonthsKey, nil, [NSBundle mainBundle], @"%d months ago", @"kJQTimeAgoStringsMonthsKey"), kJQTimeAgoStringsMonthsKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsYearKey, nil, [NSBundle mainBundle], @"1 year ago", @"kJQTimeAgoStringsYearKey"), kJQTimeAgoStringsYearKey,
                                      NSLocalizedStringWithDefaultValue(kJQTimeAgoStringsYearsKey, nil, [NSBundle mainBundle], @"%d years ago", @"kJQTimeAgoStringsYearsKey"), kJQTimeAgoStringsYearsKey,
                                      nil];
            
            
            [[NSUserDefaults standardUserDefaults] registerDefaults: settings];
        }
    });
}




@end

NSString* const kJQTimeAgoAllowFutureKey = @"kJQTimeAgoAllowFutureKey";
NSString* const kJQTimeAgoStringsPrefixAgoKey = @"kJQTimeAgoStringsPrefixAgoKey";
NSString* const kJQTimeAgoStringsPrefixFromNowKey = @"kJQTimeAgoStringsPrefixFromNowKey";
NSString* const kJQTimeAgoStringsSuffixAgoKey = @"kJQTimeAgoStringsSuffixAgoKey";
NSString* const kJQTimeAgoStringsSuffixFromNowKey = @"kJQTimeAgoStringsSuffixFromNowKey";
NSString* const kJQTimeAgoStringsSecondsKey = @"kJQTimeAgoStringsSecondsKey";
NSString* const kJQTimeAgoStringsMinuteKey = @"kJQTimeAgoStringsMinuteKey";
NSString* const kJQTimeAgoStringsMinutesKey = @"kJQTimeAgoStringsMinutesKey";
NSString* const kJQTimeAgoStringsHourKey = @"kJQTimeAgoStringsHourKey";
NSString* const kJQTimeAgoStringsHoursKey = @"kJQTimeAgoStringsHoursKey";
NSString* const kJQTimeAgoStringsDayKey = @"kJQTimeAgoStringsDayKey";
NSString* const kJQTimeAgoStringsDaysKey = @"kJQTimeAgoStringsDaysKey";
NSString* const kJQTimeAgoStringsMonthKey = @"kJQTimeAgoStringsMonthKey";
NSString* const kJQTimeAgoStringsMonthsKey = @"kJQTimeAgoStringsMonthsKey";
NSString* const kJQTimeAgoStringsYearKey = @"kJQTimeAgoStringsYearKey";
NSString* const kJQTimeAgoStringsYearsKey = @"kJQTimeAgoStringsYearsKey";
NSString* const kJQTimeAgoStringsNumbersKey = @"kJQTimeAgoStringsNumbersKey";
