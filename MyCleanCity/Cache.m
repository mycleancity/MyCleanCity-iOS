//
//  Cache.m
//  CupSub
//
//  Created by fliptoo on 9/25/14.
//  Copyright (c) 2014 Fliptoo. All rights reserved.
//

#import "Cache.h"

@implementation Cache

+ (NSCache *)cache {
    
    static dispatch_once_t pred;
    static NSCache *_cache = nil;
    dispatch_once(&pred, ^{ _cache = [[NSCache alloc] init]; });
    return _cache;
}

+ (NSMutableDictionary *)memory {
    
    static dispatch_once_t pred;
    static NSMutableDictionary *_memory = nil;
    dispatch_once(&pred, ^{ _memory = [[NSMutableDictionary alloc] init]; });
    return _memory;
}

+ (id)objectForKey:(NSString *)key {
    
    id object = [[Cache memory] objectForKey:key];
    if (!object) {
        object = [[Cache cache] objectForKey:key];
    }
    if (!object) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        object = [defaults objectForKey:key];
    }
    return object;
}

+ (void)removeObjectForKey:(NSString *)key {
    
    [[Cache memory] removeObjectForKey:key];
    [[Cache cache] removeObjectForKey:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void)setObject:(id)object forKey:(NSString *)key {
    
    [Cache setObject:object forKey:key type:eMemory];
}

+ (void)setObject:(id)object forKey:(NSString *)key type:(CacheType)type {
    
    if (type == eMemory) {
        [[Cache memory] setObject:object forKey:key];
    } else if (type == eCache) {
        [[Cache cache] setObject:object forKey:key];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:object forKey:key];
        [defaults synchronize];
    }
}

+ (void)clearAllMemory {
    
    [[Cache memory] removeAllObjects];
    [[Cache cache] removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[defaults dictionaryRepresentation] allKeys];
    
    for(NSString* key in keys) {
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
}

@end
