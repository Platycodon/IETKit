//
//  IETModel+Persistence.h
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModel.h"

@protocol IETModelPersistence

+ (void)initModelColums;

+ (void)setPersistencePropertyName:(NSString *)propertyName attributes:(NSString *)attributes;

+ (instancetype)persistencedModelForKey:(NSString *)identifer;

- (void)saveModel;

- (void)deleteModel;

+ (void)deleteAllModels;

+ (NSArray *)allModels;

+ (NSArray *)getLimitModelsWith:(NSInteger)limit;

+ (NSArray *)allModelsOrderBy:(NSString *)key sortWay:(NSString *)way;

+ (NSArray *)searchedModelsWithSearchKeyWord:(NSString *)keyWord key:(NSString *)key;

+ (void)regiserModelClass:(Class)modelClass;

@end

@interface IETModel (Persistence)<IETModelPersistence>

+ (void)initModelColums NS_REQUIRES_SUPER;


@end
