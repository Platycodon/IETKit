//
//  IETModel+Cache.h
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModel.h"

@interface IETModel (Cache)

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *cacheKey;

- (void)cache;
- (instancetype)cachedModelForKey:(NSString *)key;


- (BOOL)hasLocalCache;
- (void)localCache;
- (void)removeLocalCache;

+ (nullable NSArray<IETModel *> *)localCaches;
+ (void)removeAllLocalCaches;

@end

NS_ASSUME_NONNULL_END
