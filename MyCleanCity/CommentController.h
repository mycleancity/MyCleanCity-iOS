//
//  CommentController.h
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"
#import "TextView.h"

@interface CommentController : BaseController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *holderContraint;
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet TextView *msgField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) NSNumber *complaintID;
@property (nonatomic, strong) NSNumber *culpritID;
@property (nonatomic, strong) NSNumber *thinkBoxID;

- (IBAction)send:(id)sender;

@end
