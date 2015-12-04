//
//  ThinkBoxController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ThinkBoxController.h"
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
#import "Util.h"
#import "SupportersController.h"
#import "SupportController.h"
#import "SimpleButton.h"

@interface ThinkBoxController ()

@end

@implementation ThinkBoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = [[[self.thinkbox objectForKey:@"category"] valueForKey:@"name"] uppercaseString];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    self.titleLbl.text = [self.thinkbox objectForKey:@"title"];
    self.descLbl.text = [self.thinkbox objectForKey:@"description"];
    self.statusLbl.text = [self.thinkbox objectForKey:@"statusDisplay"];
    self.reportedByLbl.text = [self.thinkbox objectForKey:@"contactName"];
    self.reportedOnLbl.text = [self.thinkbox objectForKey:@"create_date"];
    self.zoneLbl.text = [[self.thinkbox objectForKey:@"zone"] valueForKey:@"name"];
    self.feasibilityLbl.text = [Util feasibility:[[self.thinkbox objectForKey:@"feasibility"] intValue]];
    
    self.status = [[self.thinkbox valueForKey:@"status"] intValue];
    int totalDays = [[self.thinkbox valueForKey:@"kickoffCount"] intValue];
    self.supportCount = [[self.thinkbox valueForKey:@"supportCount"] intValue];
    
    
    int commentCount = [[self.thinkbox valueForKey:@"commentCount"] intValue];
    self.progressBar.progress = (double)self.supportCount/totalDays;
    self.slaLbl.text = [NSString stringWithFormat:@"%i/%i signatures required", self.supportCount, totalDays];
    [self.commentButton setTitle:[NSString stringWithFormat:@"Comment (%i)", commentCount] forState:UIControlStateNormal];
    
    self.supported = [[self.thinkbox valueForKey:@"supported"] boolValue];
    if (self.status == 0) {
        self.supportButton.hidden = YES;
    } else {
        self.supportButton.hidden = self.supported;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/600/%@", HOST,
                                       [self.thinkbox objectForKey:@"photo"]]];
    [self.photo setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.status == 0) {
        self.supportButton.hidden = YES;
    } else {
        self.supportButton.hidden = self.supported;
    }
    
    int totalDays = [[self.thinkbox valueForKey:@"kickoffCount"] intValue];
    self.progressBar.progress = (double)self.supportCount/totalDays;
    self.slaLbl.text = [NSString stringWithFormat:@"%i/%i signatures required", self.supportCount, totalDays];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
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
    else if (indexPath.section==2) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension;
        }
        
        self.detailCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame),
                                            CGRectGetHeight(self.detailCell.bounds));
        [self.detailCell setNeedsLayout];
        [self.detailCell layoutIfNeeded];
        
        CGSize size = [self.detailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (IBAction)comment:(id)sender {
    CommentController *vc = [self controller:@"Comment"];
    vc.thinkBoxID = [self.thinkbox valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)share:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/thinkbox?id=%@", HOST, [self.thinkbox valueForKey:@"ID"]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (IBAction)viewSupporter:(id)sender {
    SupportersController *vc = [self controller:@"Supporters"];
    vc.ID = [self.thinkbox valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)support:(id)sender {
    SupportController *vc = [self controller:@"Support"];
    vc.ID = [self.thinkbox valueForKey:@"ID"];
    vc.vc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
