//
//  NTLableAttr.m
//  CXNT
//
//  Created by cc on 16/11/11.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NTLableAttr.h"
#import "NSAttributedString+YYText.h"
#import <UIKit/UIKit.h>
@implementation NTLableAttr

+(instancetype)initWithFrame:(CGRect)frame withLeftImage:(UIImage *)image withString:(NSString *)title {
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax)];
    NTLableAttr *ll = [[NTLableAttr alloc]init];
    ll.frame = frame;
    NSMutableAttributedString *titleStr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeLeft attachmentSize:CGSizeMake(image.size.width+5, image.size.height) alignToFont:SYS_FONT(14) alignment:YYTextVerticalAlignmentCenter];
    [titleStr appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:SYS_FONT(14),NSForegroundColorAttributeName:ll.titleColor}]];
    [ll setAttributedText:titleStr];
    ll.size = [YYTextLayout layoutWithContainer:container text:titleStr].textBoundingSize;
    return ll;
}
-(UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = COLOR_COMMON_TEXT_GRAY;
    }
    return _titleColor;
}
@end
