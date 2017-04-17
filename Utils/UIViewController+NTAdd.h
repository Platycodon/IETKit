//
//  UIViewController+NTAdd.h
//  CXNT
//
//  Created by Lucifer on 16/9/22.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NTAdd)

- (void)showLoadingHUD;
- (void)dismissLoadingHUD;

- (void)showFailureError:(NSError *)error;
- (void)showSuccessMessage:(NSString *)message;
- (void)showWaringWithMessage:(NSString *)message;
+ (instancetype)currentViewController;

+ (instancetype)presentedViewController;


@end
