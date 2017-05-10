//
//  IETFormedModel.h
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/20.
//  Copyright © 2017年 lunan. All rights reserved.
//

#import "IETModel.h"

#import "IETModelToFormProtocol.h"

/**
 需要支持表单模型的便捷父类，不是必须继承自此类。
 */
@interface IETFormedModel : IETModel <IETModelToFormProtocol>

@property (nullable, nonatomic, strong, readonly, getter=itemsFormedFromModel) NSArray<IETFormItem *> *formedItems;


/**
 实现此方法，来对表单项进行初始化

 @return 返回初始化后的item
 */
- (nonnull NSArray *)initializeWithItems;

@end
