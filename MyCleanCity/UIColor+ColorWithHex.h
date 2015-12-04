//
//  UIColor+ColorWithHex.h
//  CupSub
//
//  Created by fliptoo on 9/25/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorWithHex)

+ (UIColor *)colorWithHexValue:(uint)hexValue;
+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;

@end
