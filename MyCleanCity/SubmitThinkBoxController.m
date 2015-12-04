//
//  SubmitThinkBoxController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/1/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "SubmitThinkBoxController.h"
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

#define iName @"Contact Name"
#define iEmail @"Email Address"
#define iMobile @"Mobile No"
#define iPhoto @"Photo"
#define iCategory @"Category of ThinkBox"
#define iTitle @"Title"
#define iDesc @"Details"
#define iFeasibility @"Feasibility"
#define iZone @"Zone"
#import "SVProgressHUD.h"
#import "User.h"

@interface SubmitThinkBoxController ()

- (void)initForm;
- (IBAction)submit:(UIBarButtonItem * __unused)button;

@end

@implementation SubmitThinkBoxController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initForm];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"SUBMIT THINKBOX";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    
    UIBarButtonItem *submitItem = [self barButtonItem:[FAKFontAwesome checkSquareIconWithSize:25]
                                               action:@selector(submit:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    self.navigationItem.rightBarButtonItems = @[submitItem];
    
    [SVProgressHUD show];
    [Api thinkBoxCategory:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *categories = [responseObject valueForKey:@"categories"];
        XLFormRowDescriptor *row = [self.form formRowWithTag:iCategory];
        NSMutableArray *cats = [[NSMutableArray alloc] init];
        for (NSDictionary *category in categories) {
            NSString *ID = [[category objectForKey:@"ID"] stringValue];
            NSString *name = [category objectForKey:@"name"];
            [cats addObject:[XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name]];
            if (!row.value)
                row.value = [XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name];
        }
        row.selectorOptions = cats.copy;
        
        [Api zones:^(NSArray *zones) {
            XLFormRowDescriptor *row = [self.form formRowWithTag:iZone];
            NSMutableArray *_zones = [[NSMutableArray alloc] init];
            for (NSDictionary *zone in zones) {
                NSString *ID = [[zone objectForKey:@"ID"] stringValue];
                NSString *name = [zone objectForKey:@"name"];
                [_zones addObject:[XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name]];
                if (!row.value)
                    row.value = [XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name];
            }
            row.selectorOptions = _zones.copy;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [UIAlertView showWithTitle:@"Alert" message:@"Failed to retrieve zones." cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Alert" message:@"Failed to retrieve category of thinkbox." cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)initForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Submit Complaint"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Contact Detail"];
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
    
    // Photo
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Upload Your Campaign Photo (Image Size 800 x 800)"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iPhoto rowType:@"XLFormRowDescriptorTypeCustom"];
    [row.cellConfigAtConfigure setObject:[UIImage imageNamed:@"Camera"] forKey:kFormImageSelectorCellDefaultImage];
    row.required = YES;
    row.cellClass = [XLFormImageSelectorCell class];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"ThinkBox Information"];
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iTitle rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:iTitle forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iDesc rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:iDesc forKey:@"textView.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Category ThinkBox"];
    [form addFormSection:section];
    
    // Category
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iCategory rowType:XLFormRowDescriptorTypeSelectorPush title:@""];
    row.required = YES;
    row.selectorTitle = @"Category";
    [row.cellConfigAtConfigure setObject:[UIFont systemFontOfSize:13] forKey:@"detailTextLabel.font"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Feasibility"];
    [form addFormSection:section];
    
    // Feasibility
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iFeasibility rowType:XLFormRowDescriptorTypeSelectorPush title:@""];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:[Util feasibility:1]];
    row.required = YES;
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:[NSNumber numberWithInt:1] displayText:[Util feasibility:1]],
                            [XLFormOptionsObject formOptionsObjectWithValue:[NSNumber numberWithInt:2] displayText:[Util feasibility:2]],
                            [XLFormOptionsObject formOptionsObjectWithValue:[NSNumber numberWithInt:3] displayText:[Util feasibility:3]]
                            ];
    [row.cellConfigAtConfigure setObject:[UIFont systemFontOfSize:13] forKey:@"detailTextLabel.font"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Zone"];
    [form addFormSection:section];
    
    // Zone
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iZone rowType:XLFormRowDescriptorTypeSelectorPush title:@""];
    row.required = YES;
    row.selectorTitle = @"Your Residential Zone";
    [row.cellConfigAtConfigure setObject:[UIFont systemFontOfSize:13] forKey:@"detailTextLabel.font"];
    [section addFormRow:row];
    
    self.form = form;
}

- (IBAction)submit:(UIBarButtonItem * __unused)button {
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    [UIAlertView showWithTitle:@"Confirmation" message:@"Please double check the accuracy of your content before submission" cancelButtonTitle:@"Submit" otherButtonTitles:@[@"Cancel"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
            [SVProgressHUD show];
            [self.view endEditing:YES];
            NSString *name = self.formValues[iName];
            NSString *email = self.formValues[iEmail];
            NSString *mobile = self.formValues[iMobile];
            NSNumber *category = [NSNumber numberWithInt:[[self.formValues[iCategory] formValue] intValue]];
            NSNumber *feasibility = [NSNumber numberWithInt:[[self.formValues[iFeasibility] formValue] intValue]];
            NSNumber *zone = [NSNumber numberWithInt:[[self.formValues[iZone] formValue] intValue]];
            NSString *title = self.formValues[iTitle];
            NSString *desc = self.formValues[iDesc];
            UIImage *photo = self.formValues[iPhoto];
            
            [Cache setObject:name forKey:kCacheName type:ePersist];
            [Cache setObject:mobile forKey:kCacheMobile type:ePersist];
            [Cache setObject:email forKey:kCacheEmail type:ePersist];
            
            [Api submitThinkBox:email mobile:mobile name:name title:title category:category description:desc feasibility:feasibility zone:zone photo:photo success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                [UIAlertView showWithTitle:@"Done" message:@"ThinkBox successfully submitted!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
            }];
        }
    }];
}

@end
