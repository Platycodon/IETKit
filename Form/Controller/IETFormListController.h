//
//  IETFormListController.h
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/17.
//  Copyright © 2017年 lunan. All rights reserved.
//


#import "IETModelTableViewController.h"
#import "IETFormItem.h"

@protocol IETModelToFormProtocol;

@interface IETFormListController : IETModelTableViewController<IETFormItemDelegate>

@property (nonatomic, strong) IETModel<IETModelToFormProtocol> *formModel;

/**
 将form内容更新至model
 */
- (void)applyFormToModel;

/**
 通过绑的的key获取到对应的item
 
 @param key 绑定的key的名称
 @return 返回对应的item
 */
- (IETFormItem *)itemForKey:(NSString *)key;

/**
 自定义配置各item的配置，子类实现，会遍历所有item并依次调用依次，选择所需配置的item进行配置
 子类的重写方法，禁止子类调用。
 
 @param item 传入的当前遍历轮次的item
 @param key 当前item对应的key
 */
- (void)configureItem:(IETFormItem *)item forKey:(NSString *)key NS_REQUIRES_SUPER;

/**
 检查所有必填项是否已填
 
 @return 如果必填项如果全填，则返回nil  否则，返回第一个未填的必填项
 */
- (IETFormItem *)checkMandatory;

@end
