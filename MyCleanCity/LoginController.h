//
//  LoginController.h
//  MyCleanCity
//
//  Created by fliptoo on 1/23/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"

@interface LoginController : BaseController

@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;

@end
