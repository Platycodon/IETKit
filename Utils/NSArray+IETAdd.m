//
//  NSArray+IETAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NSArray+IETAdd.h"

@implementation NSArray (IETAdd)

-(id)objectOrNilAtIndex:(NSInteger)index
{
    if (index < self.count && index >= 0) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end


@implementation NSMutableArray (IETAdd)

- (void)addObjectIfNotNil:(id)anObject
{
    if (anObject == nil) {
        return;
    }
    [self addObject:anObject];
}

@end
