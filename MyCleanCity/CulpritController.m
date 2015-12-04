//
//  CulpritController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CulpritController.h"
#import "Constant.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "UIViewController+BarButtonItem.h"
#import "UIImageView+AFNetworking.h"
#import "CommentController.h"
#import "UIViewController+Storyboard.h"
#import "Api+Culprit.h"
#import "Cache.h"
#import "User.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"

@interface CulpritController ()

- (void)delete;

@end

@implementation CulpritController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = [[[self.complaint objectForKey:@"category"] valueForKey:@"name"] uppercaseString];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    self.descLbl.text = [self.complaint objectForKey:@"description"];
    self.addressLbl.text = [self.complaint objectForKey:@"address"];
    if ([[self.complaint objectForKey:@"pubName"] intValue] == 1)
        self.reportedByLbl.text = [self.complaint objectForKey:@"fullname"];
    else
        self.reportedByLbl.text = @"N/A";
    self.reportedOnLbl.text = [self.complaint objectForKey:@"create_date"];
    self.youtubeLbl.text = [self.complaint objectForKey:@"youtubelink"];
    
    if ([[self.complaint objectForKey:@"repeat_offender"] intValue] == 1)
        self.repeatLbl.text = @"Yes";
    else
        self.repeatLbl.text = @"No";
    
    if (self.addressLbl.text.length == 0) self.addressLbl.text = @"N/A";
    if (self.youtubeLbl.text.length == 0) self.youtubeLbl.text = @"N/A";
    
    int commentCount = [[self.complaint valueForKey:@"commentCount"] intValue];
    int status = [[self.complaint valueForKey:@"status"] intValue];
    [self.commentButton setTitle:[NSString stringWithFormat:@"Comment (%i)", commentCount] forState:UIControlStateNormal];
    self.statusLbl.text = [self.complaint valueForKey:@"statusDisplay"];
    
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
    if (indexPath.section==3) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension;
        }
        
        self.detailCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame),
                                            CGRectGetHeight(self.detailCell.bounds));
        [self.detailCell setNeedsLayout];
        [self.detailCell layoutIfNeeded];
        
        CGSize size = [self.detailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    } else if (indexPath.section==6) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension;
        }
        
        self.addressCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame),
                                             CGRectGetHeight(self.addressCell.bounds));
        [self.addressCell setNeedsLayout];
        [self.addressCell layoutIfNeeded];
        
        CGSize size = [self.addressCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSString *youtube = [self.complaint objectForKey:@"youtubelink"];
        if (youtube.length > 0) {
            if (![youtube.uppercaseString hasPrefix:@"HTTP"])
                youtube = [NSString stringWithFormat:@"http://%@", youtube];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:youtube]];
        }
    }
}

- (IBAction)comment:(id)sender {
    CommentController *vc = [self controller:@"Comment"];
    vc.culpritID = [self.complaint valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)share:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/culprit?id=%@", HOST, [self.complaint valueForKey:@"ID"]];
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
                     [Api deleteCulprit:ID success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [SVProgressHUD showErrorWithStatus:@"Delete Successfully"];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [SVProgressHUD showErrorWithStatus:@"Delete Failed"];
                     }];
                 }
             }];
}

@end
