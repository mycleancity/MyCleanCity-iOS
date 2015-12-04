//
//  RootController.m
//  MyCleanCity
//
//  Created by fliptoo on 1/24/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "RootController.h"
#import "Cache.h"
#import "UIViewController+Storyboard.h"

@interface RootController ()

@end

@implementation RootController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([Cache objectForKey:kAuthenticated])
        [self.navigationController pushViewController:[self controller:@"Home"] animated:NO];
    else
        [self.navigationController pushViewController:[self controller:@"Login"] animated:NO];
}

@end
