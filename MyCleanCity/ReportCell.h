//
//  ReportCell.h
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *departmentLbl;
@property (nonatomic, weak) IBOutlet UILabel *receivedLbl;
@property (nonatomic, weak) IBOutlet UILabel *resolvedLbl;
@property (nonatomic, weak) IBOutlet UILabel *inprogressLbl;
@property (nonatomic, weak) IBOutlet UILabel *delayedLbl;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;

@end
