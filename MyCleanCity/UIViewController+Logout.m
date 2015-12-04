//
//  UIViewController+Logout.m
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "UIViewController+Logout.h"
#import "Cache.h"
#import "UIAlertView+Blocks.h"
#import "UIViewController+Storyboard.h"

@implementation UIViewController (Logout)

- (IBAction)logout:(id)sender {
    [UIAlertView showWithTitle:@"Confirm Logout" message:@"Are you sure you want to logout now?" cancelButtonTitle:@"No"
             otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 if (buttonIndex == 1) {
                     [Cache clearAllMemory];
                     [self.navigationController pushViewController:[self controller:@"Login"] animated:NO];
                 }
             }];
}

@end
