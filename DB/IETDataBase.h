//
//  IETDataBase.h
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "FMDB.h"

@interface IETDataBase : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (void)excuteUpdate:(NSString *)sql arguments:(NSArray *)args async:(BOOL)shouldAsync completion:(void (^)())completion errorBlock:(void (^)(NSError *error))errorBlock;

- (void)executeQuery:(NSString *)sql arguments:(NSArray *)args async:(BOOL)shouldAsync handleBlock:(NSArray* (^)(FMResultSet *resultSet))handleBlock completion:(void (^)(NSArray *result))completion errorBlock:(void (^)(NSError *error))errorBlock;

@end
