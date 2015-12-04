//
//  UIViewController+Storyboard.m
//  InstaB Cloud
//
//  Created by fong huang yee on 11/9/13.
//  Copyright (c) 2013 fong huang yee. All rights reserved.
//

#import "UIViewController+Storyboard.h"

@implementation UIViewController (Storyboard)

- (id)storyboard:(NSString *)name controller:(NSString *)identifier
{
    UIStoryboard *storyboard = self.storyboard;
    if (name) storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    if (storyboard) {
        if (identifier)
            return [storyboard instantiateViewControllerWithIdentifier:identifier];
        else
            return [storyboard instantiateInitialViewController];
    }
    return nil;
}

- (id)storyboard:(NSString *)name
{
    return [self storyboard:name controller:nil];
}

- (id)controller:(NSString *)identifier
{
    return [self storyboard:nil controller:identifier];
}

@end
