//
//  IETSeparator.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, IETSeparatorDirection) {
    IETSeparatorDirectionHorizontal = 0,
    IETSeparatorDirectionVertical
};

@interface IETSeparator : CALayer

+ (instancetype)separatorWithThickness:(CGFloat)thickness length:(CGFloat)length color:(UIColor *)color direction:(IETSeparatorDirection)direction;

@end
