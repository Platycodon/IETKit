//
//  UIBarButtonItem+IETAdd.m
//  CXNT
//
//  Created by 陆楠 on 16/9/28.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "UIBarButtonItem+IETAdd.h"

@implementation UIBarButtonItem (IETAdd)

+ (NSArray *)customBarButtonItemsWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title selectedTitle:(NSString *)selectedTitle titleColor:(UIColor *)titleColor highlightedColor:(UIColor *)highlightedColor target:(id)target selector:(SEL)selector
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateHighlighted];
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    [button setTitle:title forState:UIControlStateNormal];
    if (selectedTitle.length) {
        [button setTitle:selectedTitle forState:UIControlStateHighlighted];
        [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateSelected];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button setTitleColor:highlightedColor forState:UIControlStateDisabled];
    CGFloat inset = (selectedImage || image) ? 4.0 : 8.0;
    [button setContentEdgeInsets:UIEdgeInsetsMake(0.0, inset, 0.0, inset)];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button sizeToFit];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-10.0];
    
    return [UIDevice currentDevice].systemVersion.floatValue >= 7.0 ? @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:button]] : @[[[UIBarButtonItem alloc] initWithCustomView:button]];
//    return @[[[UIBarButtonItem alloc] initWithCustomView:button]];
}

@end
