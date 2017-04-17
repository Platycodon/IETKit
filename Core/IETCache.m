//
//  IETCache.m
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETCache.h"

#import "YYCache.h"
#import "IETModel.h"
#import "IETSession.h"
#import "NSFileManager+IETAdd.h"
#import "NSKeyedArchiver+IETAdd.h"

@interface IETCache ()

@property (nonatomic, strong) YYCache *cacheInstance;

@end

@implementation IETCache

+(instancetype)sharedObject
{
    static IETCache *cache;
    static dispatch_once_t once;
    dispatch_once (&once,^{
        cache = [IETCache new];
        cache.cacheInstance = [YYCache cacheWithName:@"com.iething.cache"];
    });
    return cache;
}

- (id)cachedObjectForKey:(NSString *)key
{
    return [_cacheInstance objectForKey:key];
}

- (void)cacheObject:(id)object forKey:(NSString *)key
{
    [_cacheInstance setObject:object forKey:key];
}

- (void)removeCachedObjectForKey:(NSString *)key
{
    [_cacheInstance removeObjectForKey:key];
}

- (BOOL)containsCachedObjectForKey:(NSString *)key
{
    return [_cacheInstance containsObjectForKey:key];
}

- (void)cleanCache
{
    return [_cacheInstance removeAllObjects];
}


- (NSArray<id> *)localCachedObjectsInDirectoryName:(NSString *)directory
{
    NSArray<NSString *> *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:directory]  error:nil];
    NSMutableArray *objects = [NSMutableArray new];
    for (NSString *str  in names) {
        [objects addObject:[NSKeyedUnarchiver unarchiveObjectWithFile:[[[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:directory] stringByAppendingPathComponent:str]]];
    }
    return objects;
}

-(id)localCachedObjectForKey:(NSString *)key directoryName:(NSString *)directory
{
    NSString *filePath = [[[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:directory] stringByAppendingPathComponent:[key stringByAppendingPathExtension:@"cache"]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)localCacheObject:(id)object forKey:(NSString *)key directoryName:(NSString *)directory
{
    NSString *filePath = [[[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:directory] stringByAppendingPathComponent:[key stringByAppendingPathExtension:@"cache"]];
    [NSKeyedArchiver archiveRootObject:object toFile:filePath createDirectoryIfNotExsits:YES];
}

- (void)removeLocalCachedObjectForKey:(NSString *)key directoryName:(NSString *)directory
{
    NSString *filePath = [[[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:directory] stringByAppendingPathComponent:[key stringByAppendingPathExtension:@"cache"]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (BOOL)containsLocalCachedObjectForKey:(NSString *)key directoryName:(NSString *)directory
{
    NSString *filePath = [[[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:directory] stringByAppendingPathComponent:[key stringByAppendingPathExtension:@"cache"]];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (void)cleanLocalCache
{
    dispatch_async(dispatch_queue_create("com.iething.cache.clean", DISPATCH_QUEUE_SERIAL), ^{
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[IETSession sharedObject] userCachePath] error:NULL];
        for (NSString *path in contents) {
            NSString *fullPath = [[[IETSession sharedObject] userCachePath] stringByAppendingPathComponent:path];
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
        }
    });
}


@end
