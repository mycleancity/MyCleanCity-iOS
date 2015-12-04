//
//  CulpritCell.m
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CulpritCell.h"
#import "FAKIonIcons.h"

@implementation CulpritCell

- (void)awakeFromNib {
    self.holder.layer.masksToBounds = YES;
    self.holder.layer.cornerRadius = 3.0f;
    
    FAKIcon *icon = [FAKIonIcons iosClockIconWithSize:15];
    NSUInteger iconLength = icon.characterCode.length;
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:icon.attributedString];
    [aString addAttribute:NSForegroundColorAttributeName
                    value:self.when.textColor
                    range:NSMakeRange(0, aString.length)];
    [aString addAttribute:NSBaselineOffsetAttributeName
                    value:[NSNumber numberWithFloat:3]
                    range:NSMakeRange(iconLength, aString.length-iconLength)];
    self.whenIcon.attributedText = aString.copy;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.desc.preferredMaxLayoutWidth = CGRectGetWidth(self.desc.frame);
}

@end
