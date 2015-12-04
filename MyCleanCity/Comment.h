//
//  Comment.h
//  MyCleanCity
//
//  Created by fliptoo on 3/3/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "JSON.h"

@class User;

@interface Comment : JSON

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *story;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) User *user;

@end
