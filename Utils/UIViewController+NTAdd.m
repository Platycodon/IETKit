//
//  UIViewController+NTAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/22.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "UIViewController+NTAdd.h"
#import "MBProgressHUD.h"
@implementation UIViewController (NTAdd)


- (void)showLoadingHUD
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}


- (void)dismissLoadingHUD
{
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)showFailureError:(NSError *)error
{
    [self dismissLoadingHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the text mode to show only text.
    if (error.code == 500) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请求超时";
    }else{
        hud.mode = MBProgressHUDModeText;
        if ([NSLocalizedString(error.userInfo[@"NSLocalizedDescription"], @"HUD message title") isEqualToString:@"请求超时。"]) {
            hud.label.text = @"请求超时";
        }else {
             hud.label.text = NSLocalizedString(error.userInfo[@"NSLocalizedDescription"], @"HUD message title");
        }
    }
    // Move to bottm center.
    
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:1.75];
    
}


- (void)showSuccessMessage:(NSString *)message
{
    [self dismissLoadingHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(message, @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:1.75];
    
}
- (void)showWaringWithMessage:(NSString *)message
{
    [self dismissLoadingHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(message, @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:1.75];
}



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


+ (UIViewController *)presentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
