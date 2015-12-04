//
//  UIViewController+Storyboard.h
//  InstaB Cloud
//
//  Created by fong huang yee on 11/9/13.
//  Copyright (c) 2013 fong huang yee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Storyboard)

- (id)storyboard:(NSString *)name controller:(NSString *)identifier;
- (id)storyboard:(NSString *)name;
- (id)controller:(NSString *)identifier;

@end
