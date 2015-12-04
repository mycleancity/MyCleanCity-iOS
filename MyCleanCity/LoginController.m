//
//  LoginController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/23/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "LoginController.h"
#import "Api+User.h"
#import "NSString+EmailValid.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "NSString+MD5.h"
#import "JSON.h"
#import "Error.h"
#import "Cache.h"
#import "UIViewController+Storyboard.h"
#import "NSObject+Error.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma - Action

- (IBAction)login:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    if (email.length <= 0) {
        [UIAlertView showOnlyWithTitle:@"Empty Email" message:@"Email is required."];
        return;
    } else if (!email.isValidEmail) {
        [UIAlertView showOnlyWithTitle:@"Invalid Email" message:@"Please enter a valid email address. Thanks!"];
        return;
    }
    
    if (password.length <= 0) {
        [UIAlertView showOnlyWithTitle:@"Empty Password" message:@"Passwords is required."];
        return;
    }
    
    [SVProgressHUD show];
    [Api signIn:email password:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.navigationController pushViewController:[self controller:@"Home"] animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self onError:operation.responseString];
    }];
}

@end
