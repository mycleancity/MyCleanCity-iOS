//
//  NSObject+Error.h
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Error;

@interface NSObject (Error)

- (void)onError:(NSString *)responseString;

@end
