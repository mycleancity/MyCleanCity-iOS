//
//  CouncillorCell.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CouncillorCell.h"

@implementation CouncillorCell

- (void)awakeFromNib {
    self.holder.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 0.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.nameLbl.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLbl.frame);
    self.emailLbl.preferredMaxLayoutWidth = CGRectGetWidth(self.emailLbl.frame);
}

@end
