//
//  IETPinyinClassifer.h
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IETPinyinClassifer : NSObject

+ (NSDictionary *)classifyObjects:(NSArray *)objects pinyinKeyPath:(NSString *)keyPath;




@end
