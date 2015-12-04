//
//  ThinkBoxController.h
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplaintDetailCell.h"
#import "YLProgressBar.h"
#import "SimpleButton.h"

@interface ThinkBoxController : UITableViewController

@property (nonatomic, strong) NSDictionary *thinkbox;
@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *descLbl;
@property (nonatomic, weak) IBOutlet UILabel *feasibilityLbl;
@property (nonatomic, weak) IBOutlet UILabel *zoneLbl;
@property (nonatomic, weak) IBOutlet UILabel *reportedByLbl;
@property (nonatomic, weak) IBOutlet UILabel *reportedOnLbl;
@property (nonatomic, weak) IBOutlet UILabel *statusLbl;
@property (nonatomic, weak) IBOutlet ComplaintDetailCell *titleCell;
@property (nonatomic, weak) IBOutlet ComplaintDetailCell *detailCell;
@property (nonatomic, weak) IBOutlet UILabel *slaLbl;
@property (nonatomic, weak) IBOutlet YLProgressBar *progressBar;
@property (nonatomic, weak) IBOutlet SimpleButton *commentButton;
@property (nonatomic, weak) IBOutlet SimpleButton *shareButton;
@property (nonatomic, weak) IBOutlet SimpleButton *supportButton;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL supported;
@property (nonatomic, assign) int supportCount;

- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)viewSupporter:(id)sender;
- (IBAction)support:(id)sender;

@end
