//
//  CulpritsController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CulpritsController.h"
#import "UIViewController+BarButtonItem.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "Api+Culprit.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "JSON.h"
#import "Error.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "CulpritCell.h"
#import "NSDate+JQTimeAgo.h"
#import "UIColor+App.h"
#import "CulpritController.h"
#import "UIViewController+Storyboard.h"

#define SIZE 20

static NSString *identifier = @"Cell";

@interface CulpritsController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL busy;
@property (nonatomic, assign) BOOL isEnd;

- (void)refresh;
- (void)next;

@end

@implementation CulpritsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"ALL CULPRITS";
    
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
    self.page = 0;
    self.isEnd = NO;
    [self.complaints removeAllObjects];
    [self next];
}

- (void)next {
    [SVProgressHUD show];
    self.busy = YES;
    [Api culprits:self.zone page:self.page++ size:SIZE success:^(NSArray *culprits) {
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        if (culprits.count == 0) return;
        [self.complaints addObjectsFromArray:culprits];
        self.isEnd = culprits.count < SIZE;
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
    CulpritCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    if (self.refreshControl && indexPath.row == self.complaints.count-1 && !self.isEnd) [self next];
    return cell;
}

- (void)configureCell:(CulpritCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *complaint = [self.complaints objectAtIndex:indexPath.row];
    NSString *desc = [complaint objectForKey:@"description"];
    NSRange stringRange = {0, MIN([desc length], 60)};
    stringRange = [desc rangeOfComposedCharacterSequencesForRange:stringRange];
    NSString *shortDesc = [desc substringWithRange:stringRange];
    if (shortDesc.length != desc.length) shortDesc = [NSString stringWithFormat:@"%@...", shortDesc];
    
    NSString *image = [complaint objectForKey:@"photo"];
    cell.desc.text = shortDesc;
    cell.category.text = [[[complaint objectForKey:@"category"] valueForKey:@"name"] uppercaseString];
    if (image)
        [cell.photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/400/%@", HOST, image]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    else
        cell.photoView.image = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    cell.when.text = [formatter dateFromString:[complaint objectForKey:@"create_date"]].timeAgo;
    
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
    CulpritController *vc = [self controller:@"Culprit"];
    vc.complaint = [self.complaints objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
