//
//  NTLableAttr.h
//  CXNT
//
//  Created by cc on 16/11/11.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "YYLabel.h"
#import <UIKit/UIKit.h>
@interface NTLableAttr : YYLabel

@property (nonatomic,strong)UIColor *titleColor;

@property (nonatomic,strong)NSString *string;
////返回的lable  大小有了  需要重新设置他的 left 和 top
+(instancetype)initWithFrame:(CGRect)frame withLeftImage:(UIImage *)image withString:(NSString *)title;
@end
