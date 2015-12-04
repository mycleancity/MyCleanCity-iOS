//
//  ReportMonthCell.h
//  MyCleanCity
//
//  Created by fliptoo on 9/28/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportMonthCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *receivedLbl;
@property (nonatomic, weak) IBOutlet UILabel *resolvedLbl;
@property (nonatomic, weak) IBOutlet UILabel *inprogressLbl;
@property (nonatomic, weak) IBOutlet UILabel *delayedLbl;

@end
