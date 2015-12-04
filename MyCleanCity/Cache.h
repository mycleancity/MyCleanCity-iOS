//
//  Cache.h
//  CupSub
//
//  Created by fliptoo on 9/25/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

typedef enum {
    eMemory,
    eCache,
    ePersist
} CacheType;

@interface Cache : NSObject

+ (id)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (void)setObject:(id)object forKey:(NSString *)key;
+ (void)setObject:(id)object forKey:(NSString *)key type:(CacheType)type;
+ (void)clearAllMemory;

@end
