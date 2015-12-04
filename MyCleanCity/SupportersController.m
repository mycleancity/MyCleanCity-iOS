//
//  SupportersController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "SupportersController.h"
#import "FAKIonIcons.h"
#import "UIViewController+Back.h"
#import "UIViewController+BarButtonItem.h"
#import "Api+ThinkBox.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "NSDate+JQTimeAgo.h"
#import "Constant.h"

static NSString *identifier = @"Cell";

@interface SupportersController ()

@property (nonatomic, strong) NSMutableArray *supporters;

@end

@implementation SupportersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"SUPPORTERS";
    self.supporters = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    [SVProgressHUD show];
    [Api supporters:self.ID success:^(NSArray *supporters) {
        [SVProgressHUD dismiss];
        self.supporters = [[NSMutableArray alloc] initWithArray:supporters];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supporters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *supporter = [self.supporters objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    cell.textLabel.text = [supporter valueForKey:@"contactName"];
    cell.detailTextLabel.text = [formatter dateFromString:[supporter objectForKey:@"create_date"]].timeAgo;
    return cell;
}

@end
