//
//  SubmitCulpritController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "SubmitCulpritController.h"
#import "XLForm.h"
#import "UIViewController+Back.h"
#import "UIViewController+BarButtonItem.h"
#import "FAKFontAwesome.h"
#import "FAKIonIcons.h"
#import "XLFormImageSelectorCell.h"
#import "Cache.h"
#import "Api+Culprit.h"
#import "UIColor+App.h"
#import "UIAlertView+Blocks.h"
#import "User.h"

#define iName @"Contact Name"
#define iPName @"Allow name to be published?"
#define iEmail @"Email Address"
#define iMobile @"Mobile No"
#define iPhoto @"Photo"
#define iCategory @"Category of Complaint"
#define iRepeated @"Is this Person A Repeat Offender?"
#define iYoutube @"Evidence Youtube Link"
#define iDesc @"Details"
#define iAddress @"Address"
#import "SVProgressHUD.h"

@interface SubmitCulpritController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

- (void)initForm;
- (void)confirmInitForm;
- (IBAction)submit:(UIBarButtonItem * __unused)button;

@end

@implementation SubmitCulpritController

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
    self.title = @"REPORT A CULPRIT";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    
    UIBarButtonItem *submitItem = [self barButtonItem:[FAKFontAwesome checkSquareIconWithSize:25]
                                               action:@selector(submit:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    self.navigationItem.rightBarButtonItems = @[submitItem];
}

- (void)initForm {
    
    NSDictionary *draf = [Cache objectForKey:kCulprit];
    if (draf) {
        [UIAlertView showWithTitle:@"Found Draft" message:@"Do you want to continue from draft?" cancelButtonTitle:@"No"
                 otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     if (buttonIndex == 1) {
                         [self confirmInitForm];
                     } else {
                         [Cache removeObjectForKey:kCulprit];
                         [self confirmInitForm];
                     }
                 }];
    } else [self confirmInitForm];
}

- (void)confirmInitForm {
    
    NSDictionary *draf = [Cache objectForKey:kCulprit];
    
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
    
    // Publish Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iPName rowType:XLFormRowDescriptorTypeBooleanCheck title:iPName];
    row.value = [NSNumber numberWithBool:YES];
    if (draf) {
        row.value = [draf objectForKey:@"pubName"];
    }
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
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"culprit.png"];
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
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Is this Person A Repeat Offender?"];
    [form addFormSection:section];
    
    // Repeat Offender
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iRepeated rowType:XLFormRowDescriptorTypeSelectorPush title:@""];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"This is my first report againt this culprit"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:[UIFont systemFontOfSize:13] forKey:@"detailTextLabel.font"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:[NSNumber numberWithBool:NO] displayText:@"This is my first report againt this culprit"],
                            [XLFormOptionsObject formOptionsObjectWithValue:[NSNumber numberWithBool:YES] displayText:@"I have reported against this person before"]
                            ];
    if (draf) {
        BOOL repeated = [[draf valueForKey:@"repeated"] boolValue];
        if (repeated) {
            row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"I have reported against this person before"];
        } else {
            row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"This is my first report againt this culprit"];
        }
    }
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
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Culprit Information"];
    [form addFormSection:section];
    
    // Youtube
    row = [XLFormRowDescriptor formRowDescriptorWithTag:iYoutube rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Youtube Link" forKey:@"textField.placeholder"];
    row.required = NO;
    if (draf) {
        row.value = [draf objectForKey:@"youtube"];
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
    
    [Api culpritCategory:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSString *youtube = self.formValues[iYoutube];
    NSNumber *category = [NSNumber numberWithInt:[[self.formValues[iCategory] formValue] intValue]];
    NSString *desc = self.formValues[iDesc];
    NSString *address = self.formValues[iAddress];
    UIImage *photo = self.formValues[iPhoto];
    NSNumber *lat = [NSNumber numberWithDouble:self.location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:self.location.coordinate.longitude];
    BOOL repeated = [NSNumber numberWithInt:[[self.formValues[iRepeated] formValue] boolValue]];
    BOOL pubName = [self.formValues[iPName] boolValue];
   
    [Cache setObject:mobile forKey:kCacheMobile type:ePersist];
    [Cache setObject:email forKey:kCacheEmail type:ePersist];
    
    [Api submitCulprit:email mobile:mobile name:name category:category description:desc address:address lat:lat lon:lon photo:photo pName:pubName repeated:repeated youtube:youtube success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [Cache removeObjectForKey:kCulprit];
        [UIAlertView showWithTitle:@"Done" message:@"Culprit successfully reported!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Ops" message:@"Submission Failed. Do you want to save as draft and try again later?" cancelButtonTitle:@"No"
                 otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     if (buttonIndex == 1) {
                         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         NSString *documentsPath = [paths objectAtIndex:0];
                         NSString *filePath = [documentsPath stringByAppendingPathComponent:@"culprit.png"];
                         [UIImagePNGRepresentation(photo) writeToFile:filePath atomically:YES];
                         NSDictionary *draft = @{@"name":name,
                                                 @"email":email,
                                                 @"mobile":mobile,
                                                 @"category":category,
                                                 @"youtube":youtube,
                                                 @"desc":desc,
                                                 @"address":address,
                                                 @"repeated":[NSNumber numberWithBool:repeated],
                                                 @"pubName":[NSNumber numberWithBool:pubName],
                                                 @"lat":lat,
                                                 @"lon":lon};
                         [Cache setObject:draft forKey:kCulprit type:ePersist];
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
