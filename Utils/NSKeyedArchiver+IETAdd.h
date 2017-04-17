//
//  NSKeyedArchiver+IETAdd.h
//  CXNT
//
//  Created by Lucifer on 16/9/23.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyedArchiver (IETAdd)

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path createDirectoryIfNotExsits:(BOOL)create;

@end
