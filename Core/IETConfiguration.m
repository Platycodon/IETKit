//
//  IETConfiguration.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETConfiguration.h"
#import "IETSystemDriver.h"

@implementation IETConfiguration

-(instancetype)init
{
    if (self = [super init]) {
        _driverClass = [IETSystemDriver class];
    }
    return self;
}

+(instancetype)defaultConfiguration
{
    static IETConfiguration *configuration;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        configuration = [[[self class] alloc] init];
    });
    return configuration;
}

@end
