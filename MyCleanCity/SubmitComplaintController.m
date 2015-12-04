//
//  SubmitComplaintController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/26/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "SubmitComplaintController.h"
#import "XLForm.h"
#import "UIViewController+Back.h"
#import "UIViewController+BarButtonItem.h"
#import "FAKFontAwesome.h"
#import "FAKIonIcons.h"
#import "XLFormImageSelectorCell.h"
#import "Cache.h"
#import "Api+Complaint.h"
#import "UIColor+App.h"
#import "UIAlertView+Blocks.h"

#define iName @"Contact Name"
#define iEmail @"Email Address"
#define iMobile @"Mobile No"
#define iPhoto @"Photo"
#define iCategory @"Category of Complaint"
#define iTitle @"Title"
#define iDesc @"Details"
#define iAddress @"Address"
#import "SVProgressHUD.h"
#import "User.h"

@interface SubmitComplaintController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

- (void)initForm;
- (void)confirmInitForm;
- (IBAction)submit:(UIBarButtonItem * __unused)button;

@end

@implementation SubmitComplaintController

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
    self.title = @"SUBMIT COMPLAINT";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    
    UIBarButtonItem *submitItem = [self barButtonItem:[FAKFontAwesome checkSquareIconWithSize:25]
                                             action:@selector(submit:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    self.navigationItem.rightBarButtonItems = @[submitItem];
}

- (void)initForm {
    
    NSDictionary *draf = [Cache objectForKey:kComplaint];
    if (draf) {
        [UIAlertView showWithTitle:@"Found Draft" message:@"Do you want to continue from draft?" cancelButtonTitle:@"No"
                 otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     if (buttonIndex == 1) {
                         [self confirmInitForm];
                     } else {
                         [Cache removeObjectForKey:kComplaint];
                         [self confirmInitForm];
                     }
                 }];
    } else [self confirmInitForm];
}

- (void)confirmInitForm {
    NSDictionary *draf = [Cache objectForKey:kComplaint];
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
    if (draf) {
        row.value = [draf objectForKey:@"name"];
    } else if ([Cache objectForKey:kCacheName]) row.value = [Cache objectForKey:kCacheName];
    [section addFormRow:row];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iEmail rowType:XLFormRowDescriptorTypeEmail];
    [row.cellConfigAtConfigure setObject:iEmail forKey:@"textField.placeholder"];
    row.required = YES;
    [row addValidator:[XLFormValidator emailValidator]];
    if (draf) {
        row.value = [draf objectForKey:@"email"];
    } else if ([Cache objectForKey:kCacheEmail]) row.value = [Cache objectForKey:kCacheEmail];
    [section addFormRow:row];
    
    // Mobile
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iMobile rowType:XLFormRowDescriptorTypePhone];
    [row.cellConfigAtConfigure setObject:iMobile forKey:@"textField.placeholder"];
    row.required = YES;
    if (draf) {
        row.value = [draf objectForKey:@"mobile"];
    } else if ([Cache objectForKey:kCacheMobile]) row.value = [Cache objectForKey:kCacheMobile];
    [section addFormRow:row];
    
    // Photo
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Take Photo or Choose from Gallery"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iPhoto rowType:@"XLFormRowDescriptorTypeCustom"];
    [row.cellConfigAtConfigure setObject:[UIImage imageNamed:@"Camera"] forKey:kFormImageSelectorCellDefaultImage];
    row.required = YES;
    row.cellClass = [XLFormImageSelectorCell class];
    if (draf) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"complaint.png"];
        [row.cellConfigAtConfigure setObject:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]] forKey:kFormImageSelectorCellImageRequest];
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Category of Complaint"];
    [form addFormSection:section];
    
    // Category
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iCategory rowType:XLFormRowDescriptorTypeSelectorPush title:@""];
    row.required = YES;
    row.selectorTitle = @"Category";
    [row.cellConfigAtConfigure setObject:[UIFont systemFontOfSize:13] forKey:@"detailTextLabel.font"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Where is the place?"];
    [form addFormSection:section];
    
    // Address
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iAddress rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:iAddress forKey:@"textView.placeholder"];
    row.required = YES;
    if (draf) {
        row.value = [draf objectForKey:@"address"];
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Complaint Information"];
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iTitle rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:iTitle forKey:@"textField.placeholder"];
    row.required = YES;
    if (draf) {
        row.value = [draf objectForKey:@"title"];
    }
    [section addFormRow:row];
    
    // Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iDesc rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:iDesc forKey:@"textView.placeholder"];
    row.required = YES;
    if (draf) {
        row.value = [draf objectForKey:@"desc"];
    }
    [section addFormRow:row];
    
    self.form = form;
    
    [Api complaintCategory:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *categories = [responseObject valueForKey:@"categories"];
        XLFormRowDescriptor *row = [self.form formRowWithTag:iCategory];
        NSMutableArray *cats = [[NSMutableArray alloc] init];
        for (NSDictionary *category in categories) {
            NSString *ID = [[category objectForKey:@"ID"] stringValue];
            NSString *name = [category objectForKey:@"name"];
            [cats addObject:[XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name]];
            if (draf) {
                NSNumber *cat = [draf valueForKey:@"category"];
                if (cat.intValue == ID.intValue)
                    row.value = [XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name];
            } else if (!row.value)
                row.value = [XLFormOptionsObject formOptionsObjectWithValue:ID displayText:name];
        }
        row.selectorOptions = cats.copy;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Alert" message:@"Failed to retrieve category of complaint." cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    if (draf) {
        NSNumber *lat = [draf valueForKey:@"lat"];
        NSNumber *lon = [draf valueForKey:@"lon"];
        self.location = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
    } else {
        [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
        [SVProgressHUD showWithStatus:@"Locating"];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if(IS_OS_8_OR_LATER) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
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
    NSNumber *category = [NSNumber numberWithInt:[[self.formValues[iCategory] formValue] intValue]];
    NSString *title = self.formValues[iTitle];
    NSString *desc = self.formValues[iDesc];
    NSString *address = self.formValues[iAddress];
    UIImage *photo = self.formValues[iPhoto];
    NSNumber *lat = [NSNumber numberWithDouble:self.location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:self.location.coordinate.longitude];
    
    [Cache setObject:name forKey:kCacheName type:ePersist];
    [Cache setObject:mobile forKey:kCacheMobile type:ePersist];
    [Cache setObject:email forKey:kCacheEmail type:ePersist];
    
    [Api submitComplaint:email mobile:mobile name:name title:title category:category description:desc address:address lat:lat lon:lon photo:photo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Cache removeObjectForKey:kComplaint];
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Done" message:@"Complaint successfully submitted!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Ops" message:@"Submission Failed. Do you want to save as draft and try again later?" cancelButtonTitle:@"No"
                 otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     if (buttonIndex == 1) {
                         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         NSString *documentsPath = [paths objectAtIndex:0];
                         NSString *filePath = [documentsPath stringByAppendingPathComponent:@"complaint.png"];
                         [UIImagePNGRepresentation(photo) writeToFile:filePath atomically:YES];
                         NSDictionary *draft = @{@"name":name,
                                                 @"email":email,
                                                 @"mobile":mobile,
                                                 @"category":category,
                                                 @"title":title,
                                                 @"desc":desc,
                                                 @"address":address,
                                                 @"lat":lat,
                                                 @"lon":lon};
                         [Cache setObject:draft forKey:kComplaint type:ePersist];
                         [self.navigationController popViewControllerAnimated:YES];
                     } else [self.navigationController popViewControllerAnimated:YES];
                 }];
    }];
}

#pragma - CLLocationManager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    [ceo reverseGeocodeLocation:self.location
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  [SVProgressHUD dismiss];
                  if (!error) {
                      CLPlacemark *placemark = placemarks.lastObject;
                      NSString *address = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      XLFormRowDescriptor *row = [self.form formRowWithTag:iAddress];
                      row.value = address;
                      [self.tableView reloadData];
                  } else {
                      [UIAlertView showWithTitle:@"Your location can't be found" message:@"Please make sure you have turn on your location service." cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          [self.navigationController popViewControllerAnimated:YES];
                      }];
                  }
              }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    [UIAlertView showWithTitle:@"Your location can't be found" message:@"Please make sure you have turn on your location service." cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
