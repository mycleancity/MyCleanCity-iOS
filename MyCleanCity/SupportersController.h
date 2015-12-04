//
//  SupportersController.h
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "BaseController.h"

@interface SupportersController : BaseController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSNumber *ID;

@end
