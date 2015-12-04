//
//  UIColor+ColorWithHex.m
//  CupSub
//
//  Created by fliptoo on 9/25/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import "UIColor+ColorWithHex.h"

@implementation UIColor (ColorWithHex)

+ (UIColor *)colorWithHexValue:(uint)hexValue {
    return [UIColor colorWithHexValue:hexValue andAlpha:1.0f];
}

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [UIColor colorWithHexString:hexString andAlpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha {
    UIColor *col;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue andAlpha:alpha];
    } else {
        NSLog(@"ERROR: calling [UIColor colorWithHexString:andAlpha] with an invalid hex string: '%@'", hexString);
        col = [self blackColor];
    }
    return col;
}

@end
