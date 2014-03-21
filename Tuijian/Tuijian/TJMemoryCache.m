//
//  TJMemoryCache.m
//  Tuijian
//
//  Created by zhang kai on 3/21/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMemoryCache.h"

@implementation TJMemoryCache

+(id)sharedMemoryCache
{
    static TJMemoryCache *memoryCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        memoryCache = [[TJMemoryCache alloc]init];
    });
    return memoryCache;
}
@end
