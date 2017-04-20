//
//  UIButton+IETAdd.m
//  USky
//
//  Created by 陆楠 on 2017/3/15.
//  Copyright © 2017年 CETC. All rights reserved.
//

#import "UIButton+IETAdd.h"

@implementation UIButton (IETAdd)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGRect rect = CGRectMake(0, 0, 4, 4);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:[myImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)] forState:state];
}



@end
