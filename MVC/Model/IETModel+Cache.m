//
//  IETModel+Cache.m
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModel+Cache.h"
#import "IETCache.h"
#import "NSString+IETAdd.h"

#import "IETSession.h"

static char modelCacheNameKey;

@implementation IETModel (Cache)

+ (NSString *)localCacheDirectory
{
    return NSStringFromClass(self);
}

- (NSString *)cacheKey
{
    NSString *key = objc_getAssociatedObject(self, &modelCacheNameKey);
    if (!key) {
        key = [NSString stringWithUuid];
        [self setCacheKey:key];
    }
    return key;
}

- (void)setCacheKey:(NSString *)cacheKey
{
    objc_setAssociatedObject(self, &modelCacheNameKey, cacheKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)cache
{
    [[IETCache sharedObject] cacheObject:self forKey:[self cacheKey]];
}

- (instancetype)cachedModelForKey:(NSString *)key
{
    return [[IETCache sharedObject] cachedObjectForKey:key];
}

- (BOOL)hasLocalCache
{
    return [[IETCache sharedObject] containsLocalCachedObjectForKey:[self cacheKey] directoryName:[[self class] localCacheDirectory]];
}

- (void)localCache
{
    [[IETCache sharedObject] localCacheObject:self forKey:[self cacheKey] directoryName:[[self class] localCacheDirectory]];
}

- (void)removeLocalCache
{
    [[IETCache sharedObject] removeLocalCachedObjectForKey:[self cacheKey] directoryName:[[self class] localCacheDirectory]];
}

+ (NSArray<IETModel *> *)localCaches
{
    NSString *path = [[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:[[self class] localCacheDirectory]];
    NSMutableArray *caches = [NSMutableArray new];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *p in contents) {
        NSString *fullPath = [path stringByAppendingPathComponent:p];
        IETModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        model.cacheKey = [fullPath.lastPathComponent stringByDeletingPathExtension];
        [caches addObject:model];
    }
    return caches;
}

+ (void)removeAllLocalCaches
{
    NSString *path = [[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:[self localCacheDirectory]];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *p in contents) {
        NSString *fullPath = [path stringByAppendingPathComponent:p];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    }
}

@end
