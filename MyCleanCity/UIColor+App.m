//
//  UIColor+App.m
//  Workshop
//
//  Created by fliptoo on 1/23/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "UIColor+App.h"
#import "UIColor+ColorWithHex.h"

@implementation UIColor (App)

+ (UIColor *)green {
    return [UIColor colorWithHexString:@"8DC167"];
}

+ (UIColor *)lightGreen {
    return [UIColor colorWithHexString:@"99CC67"];
}

+ (UIColor *)dark {
    return [UIColor colorWithHexString:@"4A4A4A"];
}

+ (UIColor *)blue {
    return [UIColor colorWithHexString:@"75D2FB"];
}

@end
