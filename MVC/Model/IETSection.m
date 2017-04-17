//
//  IETSection.m
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETSection.h"

@implementation IETSection

-(NSMutableArray *)models
{
    if (_models == nil) {
        _models = [NSMutableArray new];
    }
    return _models;
}

@end
