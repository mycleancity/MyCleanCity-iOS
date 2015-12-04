//
//  ReportDetailController.m
//  MyCleanCity
//
//  Created by fliptoo on 9/28/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ReportDetailController.h"
#import "Api+Department.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "ReportHeaderCell.h"
#import "ReportMonthCell.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "FAKIonIcons.h"
#import "UIViewController+BarButtonItem.h"
#import "UIViewController+Back.h"

@interface ReportDetailController ()

@property (nonatomic, strong) NSDictionary *department;
@property (nonatomic, strong) NSArray *months;

@end

@implementation ReportDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"REPORT CARD";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    [SVProgressHUD show];
    [Api findDepartment:self.ID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        self.department = responseObject;
        self.months = [self.department valueForKey:@"results"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.months.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *H_CELL = @"H_CELL";
    static NSString *M_CELL = @"M_CELL";
    
    if (indexPath.row == 0) {
        ReportHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:H_CELL forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        ReportMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:M_CELL forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ReportHeaderCell *_cell = (ReportHeaderCell *)cell;
        NSString *image = [self.department objectForKey:@"Photo"];
        _cell.departmentLbl.text = [self.department objectForKey:@"DepartmentName"];
        _cell.nameLbl.text = [self.department objectForKey:@"Head"];
         if (image)
            [_cell.photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/400/%@", HOST, image]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
        else
            _cell.photoView.image = nil;
        
    } else {
        NSDictionary *month = [self.months objectAtIndex:indexPath.row-1];
        ReportMonthCell *_cell = (ReportMonthCell *)cell;
        _cell.nameLbl.text = [month objectForKey:@"Month"];
        _cell.receivedLbl.text = [NSString stringWithFormat:@"Total Received: %@", [month objectForKey:@"Received"]];
        _cell.inprogressLbl.text = [NSString stringWithFormat:@"In Progress: %@", [month objectForKey:@"InProgress"]];
        _cell.delayedLbl.text = [NSString stringWithFormat:@"Delayed: %0.2f", ((NSNumber *)[month objectForKey:@"Delayed"]).doubleValue];
        _cell.resolvedLbl.text = [NSString stringWithFormat:@"Total Resolved: %@", [month objectForKey:@"Resolved"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 130;
    } else {
        return 180;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 130;
    } else {
        return 180;
    }
}

@end
