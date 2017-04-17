//
//  IETModel.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface IETModel : NSObject <YYModel>

@property(nonatomic, copy) NSString *identifer;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
