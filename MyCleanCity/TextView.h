//
//  TextView.h
//  meconnect
//
//  Created by javatar on 6/17/13.
//  Copyright (c) 2013 fliptoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;


-(void)textChanged:(NSNotification*)notification;

@end
