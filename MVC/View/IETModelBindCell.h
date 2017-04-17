//
//  IETModelBindCell.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IETModelBindProtocol.h"
@interface IETModelBindCell : UITableViewCell <IETModelBindProtocol>

@property (nonatomic, strong, readonly) UIView *separator;

@end
