//
//  CouncillorsController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CouncillorsController.h"
#import "UIViewController+BarButtonItem.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "Api+Councillor.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "JSON.h"
#import "Error.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "CouncillorCell.h"
#import "NSDate+JQTimeAgo.h"
#import "UIColor+App.h"
#import "UIViewController+Storyboard.h"
#import "CouncillorController.h"

#define SIZE 100

static NSString *identifier = @"Cell";

@interface CouncillorsController ()

@property (nonatomic, strong) NSMutableArray *councillors;

@end

@implementation CouncillorsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"MY COUNCILLOR";
    self.councillors = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    [SVProgressHUD show];
    [Api councillors:^(NSArray *councillors) {
        [SVProgressHUD dismiss];
        self.councillors = [[NSMutableArray alloc] initWithArray:councillors];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.councillors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouncillorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CouncillorCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *councillor = [self.councillors objectAtIndex:indexPath.row];
    NSString *image = [councillor objectForKey:@"photo"];
    cell.nameLbl.text = [councillor objectForKey:@"name"];
    cell.emailLbl.text = [councillor objectForKey:@"email"];
    cell.zoneLbl.text = [[[councillor objectForKey:@"zone"] valueForKey:@"name"] uppercaseString];
    if (image)
        [cell.photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/400/%@", HOST, image]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    else
        cell.photoView.image = nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CouncillorController *vc = [self controller:@"Councillor"];
    vc.councillor = [self.councillors objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
