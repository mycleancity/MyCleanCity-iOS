//
//  ComplaintsController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/26/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ComplaintsController.h"
#import "UIViewController+BarButtonItem.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "Api+Complaint.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "JSON.h"
#import "Error.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "ComplaintCell.h"
#import "NSDate+JQTimeAgo.h"
#import "UIColor+App.h"
#import "ComplaintController.h"
#import "UIViewController+Storyboard.h"
#import "CommentController.h"
#import "SVPullToRefresh.h"

#define SIZE 20

static NSString *identifier = @"Cell";

@interface ComplaintsController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL busy;
@property (nonatomic, assign) BOOL isEnd;

- (void)refresh;
- (void)next;

@end

@implementation ComplaintsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"RESIDENT COMPLAINTS";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    if (self.complaints) {
        [self.tableView reloadData];
    } else {
        self.complaints = [[NSMutableArray alloc] init];
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refresh)
                      forControlEvents:UIControlEventValueChanged];
        self.refreshControl.tintColor = [UIColor green];
        [self.tableView addSubview:self.refreshControl];
        [self refresh];
    }
}

#pragma mark - Private

- (void)refresh {
    self.busy = NO;
    self.isEnd = NO;
    self.page = 1;
    [self.complaints removeAllObjects];
    [self next];
}

- (void)next {
    [SVProgressHUD show];
    self.busy = YES;
    [Api complaints:self.zone page:self.page++ size:SIZE success:^(NSArray *complaints) {
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        if (complaints.count == 0) return;
        [self.complaints addObjectsFromArray:complaints];
        self.isEnd = complaints.count < SIZE;
        [self.tableView reloadData];
        self.busy = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
        self.busy = NO;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.complaints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    if (self.refreshControl && indexPath.row == self.complaints.count-1 && !self.isEnd) [self next];
    return cell;
}

- (void)configureCell:(ComplaintCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *complaint = [self.complaints objectAtIndex:indexPath.row];
    NSString *desc = [complaint objectForKey:@"description"];
    NSRange stringRange = {0, MIN([desc length], 40)};
    stringRange = [desc rangeOfComposedCharacterSequencesForRange:stringRange];
    NSString *shortDesc = [desc substringWithRange:stringRange];
    if (shortDesc.length != desc.length) shortDesc = [NSString stringWithFormat:@"%@...", shortDesc];
    
    NSString *image = [complaint objectForKey:@"photo"];
    cell.callback = self;
    cell.complaintID = [complaint objectForKey:@"ID"];
    cell.title.text = [complaint objectForKey:@"title"];
    cell.desc.text = shortDesc;
    cell.category.text = [[[complaint objectForKey:@"category"] valueForKey:@"name"] uppercaseString];
    if (image)
        [cell.photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/400/%@", HOST, image]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    else
        cell.photoView.image = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    cell.when.text = [formatter dateFromString:[complaint objectForKey:@"create_date"]].timeAgo;
    
    int totalDays = [[complaint valueForKey:@"slaTotalDays"] intValue];
    int leftoverDays = [[complaint valueForKey:@"slaLeftoverDays"] intValue];
    int currentDays = totalDays-leftoverDays;
    
    int commentCount = [[complaint valueForKey:@"commentCount"] intValue];
    if (commentCount > 99) commentCount = 99;
    cell.commentBadgeLbl.text = [NSString stringWithFormat:@"%i", commentCount];
    cell.progressBar.progress = (double)(totalDays-leftoverDays)/totalDays;
    cell.statusLabel.text = [NSString stringWithFormat:@"In Progress %i/%i", currentDays, totalDays];
    
    if (cell.title.text.length == 0) cell.title.text = @"N/A";
    if (cell.desc.text.length == 0) cell.desc.text = @"N/A";
    if (cell.category.text.length == 0) cell.category.text = @"N/A";
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ComplaintController *vc = [self controller:@"Complaint"];
    vc.complaint = [self.complaints objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onCallback:(id)object type:(int)type {
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *ID = object;
        if (type == 0) {
            CommentController *vc = [self controller:@"Comment"];
            vc.complaintID = ID;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
        }
    }
}

@end
