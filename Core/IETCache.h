//
//  IETCache.h
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IETCache : NSObject

+ (instancetype)sharedObject;

- (id)cachedObjectForKey:(NSString *)key;

- (void)cacheObject:(id)object forKey:(NSString *)key;

- (void)removeCachedObjectForKey:(NSString *)key;

- (BOOL)containsCachedObjectForKey:(NSString *)key;

- (void)cleanCache;

- (NSArray<id> *)localCachedObjectsInDirectoryName:(NSString *)directory;

- (id)localCachedObjectForKey:(NSString *)key directoryName:(NSString *)directory;

- (void)localCacheObject:(id)object forKey:(NSString *)key directoryName:(NSString *)directory;

- (void)removeLocalCachedObjectForKey:(NSString *)key directoryName:(NSString *)directory;

- (BOOL)containsLocalCachedObjectForKey:(NSString *)key directoryName:(NSString *)directory;

- (void)cleanLocalCache;

@end
