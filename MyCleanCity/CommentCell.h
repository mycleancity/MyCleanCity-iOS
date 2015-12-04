//
//  CommentCell.h
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface CommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *author;
@property (nonatomic, weak) IBOutlet UILabel *story;
@property (nonatomic, weak) IBOutlet UILabel *whenIcon;
@property (nonatomic, weak) IBOutlet UILabel *when;

- (void)update:(Comment *)comment;

@end
