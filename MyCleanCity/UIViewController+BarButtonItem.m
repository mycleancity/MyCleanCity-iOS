//
//  UIViewController+BarButtonItem.m
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "UIViewController+BarButtonItem.h"
#import "IconButton.h"

@implementation UIViewController (BarButtonItem)

- (UIBarButtonItem *)barButtonItem:(FAKIcon *)icon action:(SEL)action {
    IconButton *button =[[IconButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setIcon:icon insets:UIEdgeInsetsMake(0, 0, 0, 0)];
    button.backgroundColor= [UIColor clearColor];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
