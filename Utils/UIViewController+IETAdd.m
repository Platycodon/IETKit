//
//  UIViewController+IETAdd.m
//  USky
//
//  Created by 陆楠 on 2017/3/23.
//  Copyright © 2017年 CETC. All rights reserved.
//

#import "UIViewController+IETAdd.h"

@implementation UIViewController (IETAdd)
+(instancetype)currentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return [self findTopViewControllerInController:result];
}

+ (instancetype)findTopViewControllerInController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewControllerInController:[((UITabBarController *)controller) selectedViewController]];
    }else if ([controller isKindOfClass:[UINavigationController class]]){
        return [self findTopViewControllerInController:[((UINavigationController *)controller) visibleViewController]];
    }else if ([controller isKindOfClass:[UIViewController class]]){
        return controller;
    }else{
        return nil;
    }
}

@end
