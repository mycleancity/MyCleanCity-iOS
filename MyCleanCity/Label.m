//
//  Label.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "Label.h"

@implementation Label

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    [super layoutSubviews];
}

@end
