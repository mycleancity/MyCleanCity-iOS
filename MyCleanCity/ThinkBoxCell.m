//
//  ThinkBoxCell.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "ThinkBoxCell.h"
#import "FAKIonIcons.h"
#import "UIColor+App.h"

@implementation ThinkBoxCell

- (void)awakeFromNib {
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
    
    //    self.commentBadge = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    self.commentBadge.badgeBackgroundColor = [UIColor blue];
    //    self.commentBadge.hidesWhenZero = YES;
    //    self.commentBadge.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    //    [self.commentButton addSubview:self.commentBadge];
    
    FAKIcon *commentIcon = [FAKIonIcons chatbubbleIconWithSize:26];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.commentButton setImage:[commentIcon imageWithSize:CGSizeMake(26, 26)] forState:UIControlStateNormal];
    
    FAKIcon *shareIcon = [FAKIonIcons shareIconWithSize:26];
    [shareIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.shareButton setImage:[shareIcon imageWithSize:CGSizeMake(26, 20)] forState:UIControlStateNormal];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 0.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.title.preferredMaxLayoutWidth = CGRectGetWidth(self.title.frame);
    self.desc.preferredMaxLayoutWidth = CGRectGetWidth(self.desc.frame);
    self.commentBadge.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
}

- (IBAction)comment:(id)sender {
    if ([self.callback respondsToSelector:@selector(onCallback:type:)]) {
        [self.callback onCallback:self.thinkBoxID type:0];
    }
}

- (IBAction)share:(id)sender {
    if ([self.callback respondsToSelector:@selector(onCallback:type:)]) {
        [self.callback onCallback:self.thinkBoxID type:1];
    }
}


@end
