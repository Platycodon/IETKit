//
//  IETTableSeparator.h
//  CXNT
//
//  Created by 陆楠 on 16/9/27.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModel.h"
#import <UIKit/UIKit.h>

@interface IETTableSeparator : IETModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) BOOL showSeparatorLine;//是否显示分割线，默认no
@property (nonatomic, assign) UIViewContentMode contentMode;//只支持center，left，right

+ (instancetype)separatorWithHeight:(CGFloat)height title:(NSString *)title;
+ (instancetype)separatorWithHeight:(CGFloat)height title:(NSString *)title backgroundColor:(UIColor *)color;

@end
