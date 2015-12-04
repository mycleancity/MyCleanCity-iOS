//
//  ReportDetailController.h
//  MyCleanCity
//
//  Created by fliptoo on 9/28/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"

@interface ReportDetailController : BaseController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSNumber *ID;

@end
