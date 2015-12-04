//
//  Util.h
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (NSData *)dataFromImage:(UIImage *)image metadata:(NSDictionary *)metadata mimetype:(NSString *)mimetype;
+ (NSString *)feasibility:(int)value;

@end
