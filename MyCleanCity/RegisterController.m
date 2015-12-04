//
//  RegisterController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/23/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "RegisterController.h"
#import "NSString+EmailValid.h"
#import "UIAlertView+Blocks.h"
#import "Api+User.h"
#import "NSString+MD5.h"
#import "SVProgressHUD.h"
#import "JSON.h"
#import "Error.h"
#import "Api+User.h"
#import "Cache.h"
#import "UIViewController+Storyboard.h"
#import "NSObject+Error.h"

@interface RegisterController ()

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma - Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)register:(id)sender {
    
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *name = self.nameField.text;
    
    if (self.emailField.text.length <= 0) {
        [UIAlertView showOnlyWithTitle:@"Empty Email" message:@"Email is required."];
        return;
    } else if (!self.emailField.text.isValidEmail) {
        [UIAlertView showOnlyWithTitle:@"Invalid Email" message:@"Please enter a valid email address. Thanks!"];
        return;
    }
    
    if (self.passwordField.text.length <= 0) {
        [UIAlertView showOnlyWithTitle:@"Empty Password" message:@"Password is required."];
        return;
    }
    
    if (self.cPasswordField.text.length <= 0) {
        [UIAlertView showOnlyWithTitle:@"Empty Confirm Password" message:@"Confirm Password is required."];
        return;
    }
    
    if (![self.passwordField.text isEqual:self.cPasswordField.text]) {
        [UIAlertView showOnlyWithTitle:@"Password Not Match" message:@"Confirm password does not match."];
        return;
    }
    
    if (self.nameField.text.length <= 0) {
        [UIAlertView showOnlyWithTitle:@"Empty Name" message:@"Name is required."];
        return;
    }
    
    [SVProgressHUD show];
    [Api register:email password:password name:name success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [Api signIn:email
           password:password
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                [self.navigationController pushViewController:[self controller:@"Home"] animated:YES];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [self onError:operation.responseString];
            }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self onError:operation.responseString];
    }];
}

@end
