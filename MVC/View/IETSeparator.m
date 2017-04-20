//
//  IETSeparator.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETSeparator.h"
#import "CALayer+IETAdd.h"

@implementation IETSeparator

+ (instancetype)separatorWithThickness:(CGFloat)thickness length:(CGFloat)length color:(UIColor *)color direction:(IETSeparatorDirection)direction {
    IETSeparator *layer = [IETSeparator layer];
    layer.backgroundColor = color.CGColor;
    if (direction == IETSeparatorDirectionHorizontal) {
        layer.size = CGSizeMake(length, thickness);
    }else{
        layer.size = CGSizeMake(thickness, length);
    }
    return layer;
}

@end
