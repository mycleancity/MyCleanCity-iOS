//
//  IconButton.m
//  CupSub
//
//  Created by fliptoo on 9/25/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import "IconButton.h"
#import "FAKIcon.h"
#import "FAKIonIcons.h"
#import "UIColor+ColorWithHex.h"

@interface IconButton ()

@property (nonatomic, strong) FAKIcon *icon;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIImage *hIconImage;
@property (nonatomic, strong) UIColor *nColor;
@property (nonatomic, strong) UIColor *hColor;

- (void)updateIcon;
- (void)tweakState:(BOOL)state;

@end

@implementation IconButton

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [self setTitle:nil forState:UIControlStateNormal];
    self.nColor = [UIColor whiteColor];
    if (self.color_) self.nColor = [UIColor colorWithHexString:self.color_];
    self.hColor = [self.nColor colorWithAlphaComponent:0.5f];
    self.backgroundColor = [UIColor clearColor];
    if (self.icon_ && self.size_ > 0) {
        NSData *data = [self.icon_ dataUsingEncoding:NSASCIIStringEncoding];
        NSString *code = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        [self setIcon:[FAKIonIcons iconWithCode:code size:self.size_]
               insets:UIEdgeInsetsMake(self.top_, self.left_, self.bottom_, self.right_)];
    }
}

#pragma mark - private

- (void)updateIcon {
    
    if (!self.icon) return;
    UIFont *font = [self.icon.attributes valueForKey:NSFontAttributeName];
    [self.icon addAttribute:NSForegroundColorAttributeName value:self.nColor];
    self.iconImage = [self.icon imageWithSize:CGSizeMake(font.pointSize, font.pointSize)];
    self.iconView.image = self.iconImage;
    
    [self.icon addAttribute:NSForegroundColorAttributeName value:self.hColor];
    self.hIconImage = [self.icon imageWithSize:CGSizeMake(font.pointSize, font.pointSize)];
}

- (void)tweakState:(BOOL)state {
    
    if (self.hIconImage) {
        if (state) {
            self.iconView.image = self.hIconImage;
        }
        else {
            self.iconView.image = self.iconImage;
        }
    }
}

#pragma mark - Override

- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    if (!self.isSelected)
        [self tweakState:highlighted];
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    [self tweakState:selected];
}

#pragma mark - Public

- (void)setIcon:(FAKIcon *)icon insets:(UIEdgeInsets)insets {
    
    _icon = icon;
    UIFont *font = [self.icon.attributes valueForKey:NSFontAttributeName];
    CGFloat H = font.pointSize;
    [self.iconView removeFromSuperview];
    self.iconView = [[UIImageView alloc] initWithFrame:
                     CGRectMake(insets.left, insets.top, H, H)];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconView];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0f,
                                              self.iconView.frame.size.width+insets.right,
                                              0.0f, 0.0f)];
    [self updateIcon];
}

- (void)setColor:(UIColor *)color {
    self.nColor = color;
    self.hColor = [self.nColor colorWithAlphaComponent:0.5f];
    [self updateIcon];
}

@end
