//
//  IETFormedModel.m
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/20.
//  Copyright © 2017年 lunan. All rights reserved.
//

#import "IETFormedModel.h"
#import "NSDictionary+IETAdd.h"
#import "IETFormItem.h"

@interface IETFormedModel ()
@property (nullable, nonatomic, strong, getter=itemsFormedFromModel) NSArray<IETFormItem *> *formedItems;
@end

@implementation IETFormedModel

+ (NSArray<NSString *> *)formedKeysList {
    return @[];
}

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"formedItems"];
}

- (NSArray<IETFormItem *> *)itemsFormedFromModel {
    if (_formedItems == nil) {
        _formedItems = [self initializeWithItems];
    }
    return _formedItems;
}

- (NSArray *)initializeWithItems {
    //子类实现
    return @[];
}

- (NSDictionary *)formedModelToDictionary {
    
    NSDictionary *orDic = [[self yy_modelToJSONObject] mutableCopy];
    NSMutableDictionary *muDic = [NSMutableDictionary new];
    if ([[self class] formedKeysList].count>0) {
        for (NSString *key in [[self class] formedKeysList]) {
            [muDic setObject:[orDic objectOrNilForKey:key] ForKeyIfNotNil:key];
        }
    }else{
        for (IETFormItem *item in _formedItems) {
            [muDic setObject:[orDic objectOrNilForKey:item.bindingKey] ForKeyIfNotNil:item.bindingKey];
        }
    }
    return muDic;
}


@end
