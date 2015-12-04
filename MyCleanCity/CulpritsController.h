//
//  CulpritsController.h
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"

@interface CulpritsController : BaseController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *complaints;
@property (nonatomic, strong) NSNumber *zone;

@end
