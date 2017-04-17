//
//  NSDictionary+IETAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NSDictionary+IETAdd.h"

@implementation NSDictionary (IETAdd)

-(id)objectOrNilForKey:(id)key
{
    id o = [self objectForKey:key];
    if ([o isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        return o;
    }
}

- (id)objectOrNSNullForKey:(id)key {
    id o = [self objectForKey:key];
    if (o == nil) {
        return [NSNull null];
    }
    return o;
}

@end


@implementation NSMutableDictionary (IETAdd)

- (void)setObject:(id)anObject ForKeyIfNotNil:(NSString *)key
{
    if (anObject == nil || key.length==0) {
        return;
    }
    [self setObject:anObject forKey:key];
    
}

@end
