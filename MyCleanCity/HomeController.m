//
//  HomeController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/23/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "HomeController.h"
#import "FAKIonIcons.h"
#import "IconButton.h"
#import "UIViewController+Logout.h"
#import "UIViewController+Storyboard.h"
#import "MenuCell.h"
#import "Menu.h"
#import "UIViewController+BarButtonItem.h"

@interface HomeController ()

@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, assign) BOOL buttonPress;

- (void)SubmitComplaint;
- (void)AllComplaint;
- (void)SubmitCulprit;
- (void)AllCulprit;
- (void)SubmitThinkBox;
- (void)AllThinkBox;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"MyCleanCity";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIBarButtonItem *logoutItem = [self barButtonItem:[FAKIonIcons androidExitIconWithSize:25]
                                               action:@selector(logout:)];
    self.navigationItem.rightBarButtonItems = @[logoutItem];
    
    self.menus = @[
        [Menu initWithImage:@"SubmitComplaint" title:@"Submit Complaint" action:@"SubmitComplaint" enabled:YES],
        [Menu initWithImage:@"AllComplaint" title:@"Resident Complaints" action:@"AllComplaint" enabled:YES],
        [Menu initWithImage:@"SubmitCulprit" title:@"Report a Culprit" action:@"SubmitCulprit" enabled:YES],
        [Menu initWithImage:@"AllCulprit" title:@"View All Culprits" action:@"AllCulprit" enabled:YES],
        [Menu initWithImage:@"SubmitThinkBox" title:@"Submit to Thinkbox" action:@"SubmitThinkBox" enabled:YES],
        [Menu initWithImage:@"AllThinkBox" title:@"Resident Thinkbox" action:@"AllThinkBox"enabled:YES],
        [Menu initWithImage:@"MyCouncilor" title:@"My Councilor" action:@"MyCouncilor"enabled:YES],
        [Menu initWithImage:@"ReportCard" title:@"Report Card" action:@"ReportCard"enabled:YES]
    ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.buttonPress = NO;
}

#pragma - Private

- (void)SubmitComplaint {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"SubmitComplaint"]
                                             animated:YES];
    }
}

- (void)AllComplaint {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"Complaints"]
                                             animated:YES];
    }
}

- (void)SubmitCulprit {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"SubmitCulprit"]
                                             animated:YES];
    }
}

- (void)AllCulprit {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"Culprits"]
                                             animated:YES];
    }
}

- (void)SubmitThinkBox {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"SubmitThinkBox"]
                                             animated:YES];
    }
}

- (void)AllThinkBox {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"ThinkBoxes"]
                                             animated:YES];
    }
}

- (void)MyCouncilor {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"Councillors"]
                                             animated:YES];
    }
}

- (void)ReportCard {
    if (!self.buttonPress) {
        self.buttonPress = YES;
        [self.navigationController pushViewController:[self controller:@"Report"]
                                             animated:YES];
    }
}


#pragma - UICollectionView 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                               forIndexPath:indexPath];
    Menu *menu = [self.menus objectAtIndex:indexPath.row];
    [cell.menu setBackgroundImage:[UIImage imageNamed:menu.image] forState:UIControlStateNormal];
    [cell.menu addTarget:self action:NSSelectorFromString(menu.action)
        forControlEvents:UIControlEventTouchUpInside];
    cell.menu.enabled = menu.enabled;
    cell.title.text = menu.title;
    return cell;
}

NSInteger const CellWidth = 120;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger edgeInsets = (self.view.frame.size.width - (2 * CellWidth)) / (2 + 1);
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
}

@end
