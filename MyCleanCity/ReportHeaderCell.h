//
//  ReportHeaderCell.h
//  MyCleanCity
//
//  Created by fliptoo on 9/28/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportHeaderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *departmentLbl;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;

@end
