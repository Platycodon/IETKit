//
//  IETModelColumn.h
//  CXNT
//
//  Created by Lucifer on 16/9/21.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IETModelColumn : NSObject

@property (nonatomic, copy) NSString *columnName;
@property (nonatomic, copy) NSString *attribute;
@property (nonatomic, assign) BOOL isPrimaryKey;

@end
