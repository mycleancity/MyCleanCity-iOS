//
//  UIViewController+BarButtonItem.h
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAKIcon;

@interface UIViewController (BarButtonItem)

- (UIBarButtonItem *)barButtonItem:(FAKIcon *)icon action:(SEL)action;

@end
