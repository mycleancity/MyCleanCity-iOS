//
//  SupportController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "SupportController.h"
#import "Api+ThinkBox.h"
#import "Api+Zone.h"
#import "XLForm.h"
#import "UIViewController+Back.h"
#import "UIViewController+BarButtonItem.h"
#import "FAKFontAwesome.h"
#import "FAKIonIcons.h"
#import "XLFormImageSelectorCell.h"
#import "Cache.h"
#import "UIColor+App.h"
#import "UIAlertView+Blocks.h"
#import "Util.h"
#import "SVProgressHUD.h"
#import "ThinkBoxController.h"

#define iName @"Contact Name"
#define iEmail @"Email Address"
#define iMobile @"Mobile No"

@interface SupportController ()

- (void)initForm;
- (IBAction)submit:(UIBarButtonItem * __unused)button;

@end

@implementation SupportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"SUPPORT THIS IDEA";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    
    UIBarButtonItem *submitItem = [self barButtonItem:[FAKFontAwesome checkSquareIconWithSize:25]
                                               action:@selector(submit:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    self.navigationItem.rightBarButtonItems = @[submitItem];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initForm];
    }
    return self;
}

- (void)initForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Submit Complaint"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Supporter Detail"];
    [form addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iName rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:iName forKey:@"textField.placeholder"];
    row.required = YES;
    if ([Cache objectForKey:kCacheName]) row.value = [Cache objectForKey:kCacheName];
    [section addFormRow:row];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iEmail rowType:XLFormRowDescriptorTypeEmail];
    [row.cellConfigAtConfigure setObject:iEmail forKey:@"textField.placeholder"];
    row.required = YES;
    [row addValidator:[XLFormValidator emailValidator]];
    if ([Cache objectForKey:kCacheEmail]) row.value = [Cache objectForKey:kCacheEmail];
    [section addFormRow:row];
    
    // Mobile
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iMobile rowType:XLFormRowDescriptorTypePhone];
    [row.cellConfigAtConfigure setObject:iMobile forKey:@"textField.placeholder"];
    row.required = YES;
    if ([Cache objectForKey:kCacheMobile]) row.value = [Cache objectForKey:kCacheMobile];
    [section addFormRow:row];
    
    self.form = form;
}

- (IBAction)submit:(UIBarButtonItem * __unused)button {
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD show];
    [self.view endEditing:YES];
    NSString *name = self.formValues[iName];
    NSString *email = self.formValues[iEmail];
    NSString *mobile = self.formValues[iMobile];
    
    [Cache setObject:name forKey:kCacheName type:ePersist];
    [Cache setObject:mobile forKey:kCacheMobile type:ePersist];
    [Cache setObject:email forKey:kCacheEmail type:ePersist];
    
    [Api supportThinkBox:self.ID email:email mobile:mobile name:name success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Done" message:@"Thanks for your support!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            self.vc.supported = [NSNumber numberWithBool:YES].intValue;
            self.vc.supportCount++;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
    }];
}

@end
