//
//  User.h
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "JSON.h"

@interface User : JSON

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

@end
