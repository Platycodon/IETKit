//
//  IETDataBase.m
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETDataBase.h"

#import "FMDB.h"

static dispatch_queue_t __databaseDispatchQueue;

@interface IETDataBase()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation IETDataBase

- (instancetype)initWithPath:(NSString *)path
{
    if (self = [super init]) {
        _queue = [[FMDatabaseQueue alloc] initWithPath:path];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __databaseDispatchQueue = dispatch_queue_create("com.studyro.queue.database", 0);
        });
    }
    return self;
}

-(void)executeQuery:(NSString *)sql arguments:(NSArray *)args async:(BOOL)shouldAsync handleBlock:(NSArray *(^)(FMResultSet *))handleBlock completion:(void (^)(NSArray *))completion errorBlock:(void (^)(NSError *))errorBlock
{
    void (^block)() = ^{
        [_queue inDatabase:^(FMDatabase *db){
            FMResultSet *result = [db executeQuery:sql withArgumentsInArray:args];
            NSArray *arr = nil;
            if (handleBlock) arr = handleBlock(result);
            [result close];
            // The completion call back is always async to main queue, so that we can do nested pattern on this API.
            if (completion) {
                if (shouldAsync)
                    dispatch_async(dispatch_get_main_queue(), ^{completion(arr);});
                else
                    completion(arr);
            }
        }];
    };
    
    if (shouldAsync)
        dispatch_async(__databaseDispatchQueue, block);
    else
//        dispatch_sync(__databaseDispatchQueue, block);
        block();
}

-(void)excuteUpdate:(NSString *)sql arguments:(NSArray *)args async:(BOOL)shouldAsync completion:(void (^)())completion errorBlock:(void (^)(NSError *))errorBlock
{
    void (^block)() = ^{
        [_queue inDatabase:^(FMDatabase *db){
            [db executeUpdate:sql withArgumentsInArray:args];
            if (errorBlock && [db lastError].code != 0) {
                errorBlock([db lastError]);
            }
            else if (completion) {
                if (shouldAsync)
                    dispatch_async(dispatch_get_main_queue(), ^{completion();});
                else
                    completion();
            }
        }];
    };
    
    if (shouldAsync)
        dispatch_async(__databaseDispatchQueue, block);
    else
        dispatch_sync(__databaseDispatchQueue, block);
}

@end
