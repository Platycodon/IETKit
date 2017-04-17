//
//  IETTextField.m
//  CXNT
//
//  Created by 陆楠 on 2016/11/3.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETTextField.h"

@implementation IETTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, self.height * 0.5 - 1, 0, 0)];
}

@end
