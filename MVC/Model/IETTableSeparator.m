//
//  IETTableSeparator.m
//  CXNT
//
//  Created by 陆楠 on 16/9/27.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETTableSeparator.h"

@implementation IETTableSeparator

+ (instancetype)separatorWithHeight:(CGFloat)height title:(NSString *)title
{
    return [self separatorWithHeight:height title:title backgroundColor:[UIColor clearColor]];
}

+ (instancetype)separatorWithHeight:(CGFloat)height title:(NSString *)title backgroundColor:(UIColor *)color {
    IETTableSeparator *separator = [IETTableSeparator new];
    separator.title = title;
    separator.height = height;
    separator.backgroundColor = color;
    return separator;
}

-(instancetype)init
{
    if (self = [super init]) {
        _showSeparatorLine = NO;
        _contentMode = UIViewContentModeLeft;
    }
    return self;
}

@end
