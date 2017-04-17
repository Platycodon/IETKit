//
//  IETPersistenceRegister.m
//  CXNT
//
//  Created by Lucifer on 16/9/22.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETPersistenceRegister.h"
#import "IETModel+Persistence.h"

@implementation IETPersistenceRegister

+ (void)registerPersistenceModelClass:(Class)modelClass
{
    if (![modelClass isSubclassOfClass:[IETModel class]] || ![modelClass conformsToProtocol:@protocol(IETModelPersistence)]) {
        return;
    }
    
    [IETModel regiserModelClass:modelClass];
}

@end
