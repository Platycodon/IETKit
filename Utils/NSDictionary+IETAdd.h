//
//  NSDictionary+IETAdd.h
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IETAdd)

- (id)objectOrNilForKey:(id)key;
- (id)objectOrNSNullForKey:(id)key;

@end

@interface NSMutableDictionary (IETAdd)

- (void)setObject:(id)anObject ForKeyIfNotNil:(NSString *)key;

@end
