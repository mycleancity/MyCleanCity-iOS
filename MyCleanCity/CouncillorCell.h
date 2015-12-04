//
//  CouncillorCell.h
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouncillorCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *emailLbl;
@property (nonatomic, weak) IBOutlet UILabel *zoneLbl;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) NSNumber *councillorID;

@end
