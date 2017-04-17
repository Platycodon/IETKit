//
//  IETModelBindCell.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModelBindCell.h"
#import "IETSeparator.h"
#import "UIView+IETAdd.h"

@interface IETModelBindCell()
@property (nonatomic, strong) UIView *separator;
@end

@implementation IETModelBindCell

@synthesize model = _model;

+(CGFloat)cellHeightWithModel:(IETModel *)model
{
    return 44.0;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _separator = [UIView new];
        _separator.width = self.width;
        _separator.height = 0.5;
        _separator.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1];
        [self addSubview:_separator];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _separator.bottom = self.height;
    _separator.width = self.width;
    _separator.left = 0;
    
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    
    return CGSizeMake(size.width, totalHeight);
}


@end
