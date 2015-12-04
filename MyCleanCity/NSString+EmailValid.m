//
//  NSString+EmailValid.m
//  CincaiBuy
//
//  Created by fliptoo on 1/22/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "NSString+EmailValid.h"

@implementation NSString (EmailValid)

- (BOOL)isValidEmail {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
