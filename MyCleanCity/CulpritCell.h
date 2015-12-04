//
//  CulpritCell.h
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CulpritCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *holder;
@property (nonatomic, weak) IBOutlet UILabel *desc;
@property (nonatomic, weak) IBOutlet UILabel *category;
@property (nonatomic, weak) IBOutlet UILabel *whenIcon;
@property (nonatomic, weak) IBOutlet UILabel *when;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;

@end
