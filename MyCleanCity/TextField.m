//
//  TextField.m
//  CupSub
//
//  Created by fliptoo on 9/29/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import "TextField.h"

@implementation TextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    self.horizontalPadding = 10;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.horizontalPadding, bounds.origin.y + self.verticalPadding, bounds.size.width - self.horizontalPadding*2, bounds.size.height - self.verticalPadding*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
