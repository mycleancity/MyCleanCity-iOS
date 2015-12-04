//
//  ReportController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ReportController.h"
#import "UIViewController+BarButtonItem.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "Api+Department.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "JSON.h"
#import "Error.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "ReportCell.h"
#import "NSDate+JQTimeAgo.h"
#import "UIColor+App.h"
#import "ReportDetailController.h"
#import "UIViewController+Storyboard.h"

#define SIZE 100

static NSString *identifier = @"Cell";

@interface ReportController ()

@property (nonatomic, strong) NSMutableArray *departments;

@end

@implementation ReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"REPORT CARD";
    self.departments = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    [SVProgressHUD show];
    [Api departmentReport:^(NSArray *departments) {
        [SVProgressHUD dismiss];
        self.departments = [[NSMutableArray alloc] initWithArray:departments];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.departments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ReportCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *department = [self.departments objectAtIndex:indexPath.row];
    NSString *image = [department objectForKey:@"Photo"];
    cell.departmentLbl.text = [department objectForKey:@"DepartmentName"];
    cell.nameLbl.text = [department objectForKey:@"Head"];
    cell.receivedLbl.text = [NSString stringWithFormat:@"Total Received: %@", [department objectForKey:@"Received"]];
    cell.inprogressLbl.text = [NSString stringWithFormat:@"In Progress: %@", [department objectForKey:@"InProgress"]];
    cell.delayedLbl.text = [NSString stringWithFormat:@"Delayed: %0.2f", ((NSNumber *)[department objectForKey:@"Delayed"]).doubleValue];
    cell.resolvedLbl.text = [NSString stringWithFormat:@"Total Resolved: %@", [department objectForKey:@"Resolved"]];
    if (image)
        [cell.photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/400/%@", HOST, image]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    else
        cell.photoView.image = nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *department = [self.departments objectAtIndex:indexPath.row];
    ReportDetailController *vc = [self controller:@"ReportDetail"];
    vc.ID = [department valueForKey:@"DepartmentID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
