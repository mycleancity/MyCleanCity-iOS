//
//  IconButton.h
//  CupSub
//
//  Created by fliptoo on 9/25/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAKIcon;

@interface IconButton : UIButton

@property (nonatomic, strong) NSString *icon_;
@property (nonatomic, strong) NSString *color_;
@property (nonatomic, assign) CGFloat size_;
@property (nonatomic, assign) CGFloat top_;
@property (nonatomic, assign) CGFloat left_;
@property (nonatomic, assign) CGFloat bottom_;
@property (nonatomic, assign) CGFloat right_;

- (void)setIcon:(FAKIcon *)icon insets:(UIEdgeInsets)insets;
- (void)setColor:(UIColor *)color;

@end
