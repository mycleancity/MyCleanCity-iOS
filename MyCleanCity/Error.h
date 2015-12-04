//
//  Error.h
//  MyCleanCity
//
//  Created by fliptoo on 1/24/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "JSON.h"

@interface Error : JSON

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *error;

@end
