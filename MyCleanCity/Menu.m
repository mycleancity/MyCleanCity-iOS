//
//  Menu.m
//  MyCleanCity
//
//  Created by fliptoo on 1/25/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "Menu.h"

@implementation Menu

+ (id)initWithImage:(NSString *)image
              title:(NSString *)title
             action:(NSString *)action
            enabled:(BOOL)enabled {

    Menu *menu = [[self alloc] init];
    menu.image = image;
    menu.title = title;
    menu.action = action;
    menu.enabled = enabled;
    return menu;
}

@end
