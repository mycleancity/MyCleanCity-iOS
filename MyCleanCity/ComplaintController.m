//
//  ComplaintController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ComplaintController.h"
#import "Constant.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "UIViewController+BarButtonItem.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+App.h"
#import "CommentController.h"
#import "UIViewController+Storyboard.h"
#import "Cache.h"
#import "User.h"
#import "Api+Complaint.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"

@interface ComplaintController ()

@property (nonatomic, assign) int status;

- (void)delete;

@end

@implementation ComplaintController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = [[[self.complaint objectForKey:@"category"] valueForKey:@"name"] uppercaseString];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    self.refLbl.text = [self.complaint objectForKey:@"ref"];
    self.titleLbl.text = [self.complaint objectForKey:@"title"];
    self.descLbl.text = [self.complaint objectForKey:@"description"];
    self.addressLbl.text = [self.complaint objectForKey:@"address"];
    self.reportedByLbl.text = [self.complaint objectForKey:@"fullname"];
    self.reportedOnLbl.text = [self.complaint objectForKey:@"create_date"];
    if (self.addressLbl.text.length == 0) self.addressLbl.text = @"N/A";
    
    int status = [[self.complaint valueForKey:@"status"] intValue];
    self.status = status;
    int totalDays = [[self.complaint valueForKey:@"slaTotalDays"] intValue];
    int leftoverDays = [[self.complaint valueForKey:@"slaLeftoverDays"] intValue];
    
    int commentCount = [[self.complaint valueForKey:@"commentCount"] intValue];
    self.progressBar.progress = (double)(totalDays-leftoverDays)/totalDays;
    
    if (leftoverDays < 0)
        self.slaLbl.text = [NSString stringWithFormat:@"Overdue %i days", -leftoverDays];
    else
        self.slaLbl.text = [NSString stringWithFormat:@"%i days to go", leftoverDays];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"Comment (%i)", commentCount] forState:UIControlStateNormal];
    
    if (status == 0)
        self.statusLbl.text = @"Pending Moderation";
    else if (status == 1)
        self.statusLbl.text = @"Approved";
    else if (status == 2)
        self.statusLbl.text = @"In Progress";
    else if (status == 3)
        self.statusLbl.text = @"Invalid";
    else if (status == 4)
        self.statusLbl.text = @"Resolved";
    
    if (status == 2) {
        if (leftoverDays < 0) self.progressBar.progressTintColor = [UIColor redColor];
    } else if (status == 3) {
        self.progressBar.progressTintColor = [UIColor redColor];
    } else if (status == 4) {
        self.progressBar.progressTintColor = [UIColor green];
    }
    
    self.progressBar.hidden = YES;
    self.slaLbl.hidden = YES;
    if (self.status == 2 || self.status == 4) {
        self.progressBar.hidden = NO;
        self.slaLbl.hidden = NO;
    }
    
    User *me = [Cache objectForKey:kUserMe];
    if (status == 0 && me.ID.intValue == [[self.complaint valueForKeyPath:@"user.ID"] intValue]) {
        UIBarButtonItem *deleteItem = [self barButtonItem:[FAKIonIcons iosCloseOutlineIconWithSize:25]
                                                   action:@selector(delete)];
        self.navigationItem.rightBarButtonItems = @[deleteItem];
    }
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyApp.AppTask",NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(queue,
                   ^{
                       CLLocationCoordinate2D coordinate;
                       coordinate.latitude = [[self.complaint objectForKey:@"lat"] doubleValue];
                       coordinate.longitude = [[self.complaint objectForKey:@"longi"] doubleValue];
                       if(!CLLocationCoordinate2DIsValid(coordinate)) return;
                       
                       MKCoordinateSpan span;
                       span.longitudeDelta = 0.05;
                       span.latitudeDelta = 0.05;
                       
                       MKCoordinateRegion region;
                       region.center = coordinate;
                       region.span = span;

                       dispatch_async(main,
                                      ^{
                                          self.map.region = region;
                                          MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                                          annotation.coordinate = coordinate;
                                          [self.map addAnnotation:annotation];
                                      });
                   });
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/600/%@", HOST,
                                       [self.complaint objectForKey:@"photo"]]];
    [self.photo setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension;
        }
        
        self.titleCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame),
                                            CGRectGetHeight(self.titleCell.bounds));
        [self.titleCell setNeedsLayout];
        [self.titleCell layoutIfNeeded];
        
        CGSize size = [self.titleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else if (indexPath.section==3) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension;
        }
        
        self.detailCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame),
                                            CGRectGetHeight(self.detailCell.bounds));
        [self.detailCell setNeedsLayout];
        [self.detailCell layoutIfNeeded];
            
        CGSize size = [self.detailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    } else if (indexPath.section==5) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension;
        }
        
        self.addressCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame),
                                            CGRectGetHeight(self.addressCell.bounds));
        [self.addressCell setNeedsLayout];
        [self.addressCell layoutIfNeeded];
        
        CGSize size = [self.addressCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (IBAction)comment:(id)sender {
    CommentController *vc = [self controller:@"Comment"];
    vc.complaintID = [self.complaint valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)share:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/complaint?id=%@", HOST, [self.complaint valueForKey:@"ID"]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void)delete {
    [UIAlertView showWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this item?" cancelButtonTitle:@"No"
             otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 if (buttonIndex == 1) {
                     [SVProgressHUD show];
                     NSNumber *ID = [self.complaint valueForKey:@"ID"];
                     [Api deleteComplaint:ID success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [SVProgressHUD showErrorWithStatus:@"Delete Successfully"];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [SVProgressHUD showErrorWithStatus:@"Delete Failed"];
                     }];
                 }
             }];
}

@end
