//
//  ComplaintCell.h
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import "M13BadgeView.h"
#import "Callback.h"

@interface ComplaintCell : UITableViewCell

@property (assign, nonatomic) id <Callback> callback;
@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *desc;
@property (nonatomic, weak) IBOutlet UILabel *category;
@property (nonatomic, weak) IBOutlet UILabel *whenIcon;
@property (nonatomic, weak) IBOutlet UILabel *when;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet YLProgressBar *progressBar;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UILabel *commentBadgeLbl;
@property (nonatomic, strong) M13BadgeView *commentBadge;
@property (nonatomic, strong) NSNumber *complaintID;

- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;

@end
