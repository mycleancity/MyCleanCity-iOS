//
//  ThinkBoxesController.h
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"
#import "Callback.h"

@interface ThinkBoxesController : BaseController <Callback>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *thinkboxes;
@property (nonatomic, strong) NSNumber *zone;

@end
