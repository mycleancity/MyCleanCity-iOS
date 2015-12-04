//
//  NSObject+Error.m
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "NSObject+Error.h"
#import "UIAlertView+Blocks.h"
#import "Error.h"

@implementation NSObject (Error)

- (void)onError:(NSString *)responseString {
    NSError *err = nil;
    Error *e = [[Error alloc] initWithString:responseString error:&err];
    if (err) [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please contact your administrator"];
    else [UIAlertView showOnlyWithTitle:@"Ops..." message:e.error];
}

@end
