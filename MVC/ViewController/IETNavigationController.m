//
//  IETNavigationController.m
//  USky
//
//  Created by 陆楠 on 2017/3/17.
//  Copyright © 2017年 CETC. All rights reserved.
//

#import "IETNavigationController.h"

@interface IETNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation IETNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
}

@end
