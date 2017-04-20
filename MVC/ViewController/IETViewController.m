//
//  IETViewController.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETViewController.h"
#import "IETConfiguration.h"
#import "UIBarButtonItem+IETAdd.h"
#import "IETConfiguration.h"

@implementation IETViewController
- (void)dealloc {
    NSLog(@"dealloc:%@",[self class]);
}

-(instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        _showBackWhatever = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [IETConfiguration defaultConfiguration].vcBackgroundColor;
    if (self.navigationController) {
        self.navigationController.delegate = self;
    }
    
    if ((self.navigationController.viewControllers.count>0 && ![self.navigationController.viewControllers[0] isEqual:self]) ||
        _showBackWhatever) {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem customBarButtonItemsWithImage:[UIImage imageNamed:[IETConfiguration defaultConfiguration].backArrowName] selectedImage:[UIImage imageNamed:[IETConfiguration defaultConfiguration].backArrowName] title:nil selectedTitle:nil titleColor:nil highlightedColor:nil target:self selector:@selector(goBack)];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
