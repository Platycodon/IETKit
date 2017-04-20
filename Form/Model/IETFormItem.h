//
//  IETFormItem.h
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/17.
//  Copyright © 2017年 lunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IETFormItem;
@class IETModel;

@protocol IETFormItemDelegate <NSObject>

@optional
- (void)formItem:(IETFormItem *)item didChangeToValue:(id)value;

@end


/**
 formitem的基类，不要直接使用
 */
@interface IETFormItem : NSObject

@property (nonatomic, weak) id<IETFormItemDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *title;//表单项标题
@property (nonatomic, copy) NSString *desc;//描述/补充内容
@property (nonatomic, copy) NSDictionary *descAttributes;//desc 的文字属性

@property (nonatomic, assign) BOOL isMandatory;//是否必填项
@property (nonatomic, assign) BOOL isEditable;//是否可编辑

@property (nonatomic, weak, readonly) IETModel *bindingModel;//绑定的model,可以保证访问到原model
@property (nonatomic, copy, readonly) NSString *bindingKey;//单条填写项对应绑定的key

@property (nonatomic, strong) id value;

@property (nonatomic, copy) NSString *placeHolder;

/**
 工厂方法
 
 @param title 标题
 @param key 绑定的对应model的属性的key
 @param isMandatory 是否必填，必填项会有红色*
 @param isEditable 是否可编辑
 @param model 绑定的model
 @param placeHolder placeHolder
 @return 返回instancetype
 */
+ (instancetype)itemWithTitle:(NSString *)title bindingKey:(NSString *)key
                  isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model
                  placeHolder:(NSString *)placeHolder;

- (void)setTitle:(NSString *)title bindingKey:(NSString *)key
      isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model
      placeHolder:(NSString *)placeHolder;

/**
 将value更新至绑定的model
 */
- (void)updateValueToModel;


@end

/**
 填写项
 */
@interface IETFormFieldItem : IETFormItem

@property (nonatomic, copy) NSString *regex;//校验正则

+ (instancetype)itemWithTitle:(NSString *)title bindingKey:(NSString *)key
                  isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model
                  placeHolder:(NSString *)placeHolder;

- (BOOL)checkRegex;

@end


@class IETFormPickItem;
@protocol USFormPickItemDataSource <NSObject>

@optional
- (NSArray<NSString *> *)optionsOfPickItem:(IETFormPickItem *)item bindingKey:(NSString *)key;

@end

/**
 通用选择项
 */
@interface IETFormPickItem : IETFormItem

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id<USFormPickItemDataSource> dataSource;

+ (instancetype)itemWithTitle:(NSString *)title bindingKey:(NSString *)key
                  isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model
                  placeHolder:(NSString *)placeHolder dataSource:(id<USFormPickItemDataSource>)dataSource;

@end







