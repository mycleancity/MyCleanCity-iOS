//
//  RegisterController.h
//  MyCleanCity
//
//  Created by fliptoo on 1/23/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"

@interface RegisterController : BaseController

@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *cPasswordField;
@property (nonatomic, strong) IBOutlet UITextField *nameField;

- (IBAction)back:(id)sender;
- (IBAction)register:(id)sender;

@end
