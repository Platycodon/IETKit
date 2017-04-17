//
//  UIBarButtonItem+IETAdd.h
//  CXNT
//
//  Created by 陆楠 on 16/9/28.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIBarButtonItem (IETAdd)


+ (NSArray *)customBarButtonItemsWithImage:(UIImage *)image
                             selectedImage:(UIImage *)selectedImage
                                     title:(NSString *)title
                             selectedTitle:(NSString *)selectedTitle
                                titleColor:(UIColor *)titleColor
                          highlightedColor:(UIColor *)highlightedColor
                                    target:(id)target
                                  selector:(SEL)selector;

@end
