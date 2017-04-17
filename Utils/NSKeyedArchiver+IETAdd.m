//
//  NSKeyedArchiver+IETAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/23.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NSKeyedArchiver+IETAdd.h"

@implementation NSKeyedArchiver (IETAdd)

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path createDirectoryIfNotExsits:(BOOL)create
{
    if (create) {
        NSString *dir = [path stringByDeletingLastPathComponent];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return [self archiveRootObject:rootObject toFile:path];
}

@end
