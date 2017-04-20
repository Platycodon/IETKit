//
//  IETTableSeparatorCell.m
//  CXNT
//
//  Created by 陆楠 on 16/9/27.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETTableSeparatorCell.h"
#import "IETTableSeparator.h"
#import "IETSeparator.h"
#import "UIView+IETAdd.h"


@interface IETTableSeparatorCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IETTableSeparatorCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.separator.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

-(void)setModel:(IETTableSeparator *)model
{
    _model = model;
    _titleLabel.text = model.title;
    if (model.titleColor) {
        _titleLabel.textColor = model.titleColor;
    }
    self.separator.hidden = !model.showSeparatorLine;
    self.backgroundColor = model.backgroundColor;
    [_titleLabel sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.centerY = _model.height/2;
    if (_model.contentMode == UIViewContentModeLeft) {
        _titleLabel.left = 8;
    }else if (_model.contentMode == UIViewContentModeCenter){
        _titleLabel.centerX = self.contentView.width/2;
    }else if (_model.contentMode == UIViewContentModeRight){
        _titleLabel.right = self.contentView.width-8;
    }
}

-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, _model.height);
}

@end
