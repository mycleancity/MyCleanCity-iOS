//
//  Callback.h
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Callback <NSObject>
- (void)onCallback:(id)object type:(int)type;
@end
