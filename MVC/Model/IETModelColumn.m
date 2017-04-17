//
//  IETModelColumn.m
//  CXNT
//
//  Created by Lucifer on 16/9/21.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModelColumn.h"

@implementation IETModelColumn

-(BOOL)isEqual:(id)object
{
    if (self == object) return YES;
    
    NSString *selfColumnName = self.columnName, *otherColumnName = ((IETModelColumn *)object).columnName;
    if ([selfColumnName isEqualToString:otherColumnName]) return YES;
    
    return [super isEqual:object];
}

@end
