//
//  IETModelBindProtocol.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

@class IETModel;

@protocol IETModelBindProtocol <NSObject>

@property (nonatomic, strong) IETModel *model;

@optional
+ (CGFloat)cellHeightWithModel:(IETModel *)model;

@end
