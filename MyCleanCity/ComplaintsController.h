//
//  ComplaintsController.h
//  MyCleanCity
//
//  Created by fliptoo on 1/26/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"
#import "Callback.h"

@interface ComplaintsController : BaseController <Callback>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *complaints;
@property (nonatomic, strong) NSNumber *zone;

@end
