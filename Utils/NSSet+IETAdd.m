//
//  NSSet_IETAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/21.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NSSet+IETAdd.h"

@implementation NSSet (IETAdd)

- (BOOL)contains:(id)obj
{
    __block BOOL contains = NO;
    [self enumerateObjectsUsingBlock:^(id o, BOOL *stop) {
        if ([o isEqual:obj]) {
            *stop = YES;
            contains = YES;
        }
    }];
    
    return contains;
}

@end
