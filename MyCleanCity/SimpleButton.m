//
//  SimpleButton.m
//  InstaB Cloud
//
//  Created by fliptoo on 12/18/13.
//  Copyright (c) 2013 fong huang yee. All rights reserved.
//

#import "SimpleButton.h"
#import "UIColor+App.h"

@interface SimpleButton ()

@property (nonatomic, strong) UIColor *nColor;
@property (nonatomic, strong) UIColor *hColor;

- (void)initialize;
- (void)tweakState:(BOOL)state;

@end


@implementation SimpleButton

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    self.nColor = [UIColor green];
    self.hColor = [self.nColor colorWithAlphaComponent:0.5f];
    [self initialize];
}

#pragma mark - Private

- (void)initialize {
    self.layer.borderColor = self.nColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = [UIColor green];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)tweakState:(BOOL)state {
    if (state) {
        self.layer.borderColor = self.hColor.CGColor;
    }
    else {
        self.layer.borderColor = self.nColor.CGColor;
    }
}


#pragma mark - Public

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!self.isSelected) [self tweakState:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self tweakState:selected];
}

- (void)setColor:(UIColor *)color {
    self.nColor = color;
    self.hColor = [self.nColor colorWithAlphaComponent:0.5f];
    [self initialize];
}

@end
