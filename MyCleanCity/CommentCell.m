//
//  CommentCell.m
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "User.h"
#import "FAKIonIcons.h"
#import "NSDate+JQTimeAgo.h"

@implementation CommentCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.story.preferredMaxLayoutWidth = CGRectGetWidth(self.story.frame);
}

- (void)awakeFromNib {
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

- (void)update:(Comment *)comment {
    self.author.text = comment.user.name;
    self.story.text = comment.story;
    self.when.text = comment.date.timeAgo;
}

@end
