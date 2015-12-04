//
//  Menu.h
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) BOOL enabled;

+ (id)initWithImage:(NSString *)image
              title:(NSString *)title
             action:(NSString *)action
            enabled:(BOOL)enabled;

@end
