//
//  NSArray+IETAdd.h
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IETAdd)

- (id)objectOrNilAtIndex:(NSInteger)index;

@end


@interface NSMutableArray (IETAdd)

- (void)addObjectIfNotNil:(id)anObject;

@end
