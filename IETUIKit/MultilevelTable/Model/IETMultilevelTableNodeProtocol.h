//
//  IETMultilevelTableNodeProtocol.h
//  IETKitTest
//
//  Created by 陆楠 on 2017/5/10.
//  Copyright © 2017年 lunan. All rights reserved.
//

#ifndef IETMultilevelTableNodeProtocol_h
#define IETMultilevelTableNodeProtocol_h


@class IETModel;
@class NSArray;
@protocol IETMultilevelTableNodeProtocol <NSObject>

/**
 是否是叶子节点，如果不是叶子节点，点击后需要展开下一级
 */
@property (nonatomic, assign) BOOL isLeaf;

/**
 是否是展开状态
 */
@property (nonatomic, assign) BOOL isOpen;

/**
 该节点所包含的子节点
 */
@property (nonatomic, strong) NSArray<IETModel *> *subNodes;

/**
 节点的级别，根节点级别为0
 */
@property (nonatomic, assign) NSUInteger level;

@end


#endif /* IETMultilevelTableNodeProtocol_h */
