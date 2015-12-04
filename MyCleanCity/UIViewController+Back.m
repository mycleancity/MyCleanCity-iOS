//
//  UIViewController+Back.m
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "UIViewController+Back.h"
#import "SVProgressHUD.h"

@implementation UIViewController (Back)

- (IBAction)back:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
