//
//  IETModelToFormProtocol.h
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/17.
//  Copyright © 2017年 lunan. All rights reserved.
//

#ifndef IETModelToFormProtocol_h
#define IETModelToFormProtocol_h

@class IETFormItem;
@class NSArray;

@protocol IETModelToFormProtocol <NSObject>

@property (nullable, nonatomic, strong, readonly, getter=itemsFormedFromModel) NSArray<IETFormItem *> *formedItems;

- (nullable NSArray<IETFormItem *> *)itemsFormedFromModel;

@optional
/**
 获取在表单化中，哪些属性需要进行表单化，哪些不需要，在最后获取到的表单化的字典中，只出现这些值
 
 @return 返回属性名称的数组
 */
+ (nullable NSArray<NSString *> *)formedKeysList;

/**
 遍历所有的属性，将其转化为dictionary 并返回值，如果实现 formedKeysList 方法，则，返回相对应的键值对
 
 @return 返回转化后的键值对
 */
- (nullable NSDictionary *)formedModelToDictionary;

@end


#endif /* IETModelToFormProtocol_h */
