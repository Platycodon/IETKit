//
//  NSFileManager+IETAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NSFileManager+IETAdd.h"

@implementation NSFileManager (IETAdd)

-(NSString *)cacheDictionary
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

-(NSString *)documentDictionary
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

@end
