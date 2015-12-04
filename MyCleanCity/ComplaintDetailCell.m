//
//  ComplaintDetailCell.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ComplaintDetailCell.h"

@implementation ComplaintDetailCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.detailTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.detailTextLabel.frame);
}

@end
