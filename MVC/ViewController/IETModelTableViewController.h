//
//  IETModelTableViewController.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IETModelBindProtocol.h"
#import "IETTableView.h"

@class IETModel;

@interface IETModelTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong, readonly) IETTableView *tableView;

@property (nonatomic, strong) NSMutableArray<IETModel *> *tableModels;

@property (nonatomic, copy) NSString *since;
/**
 是否支持刷新，必须在view被presente或者push之前或在viewdidload之前被设置，否则无效，default is no
 */
@property (nonatomic, assign) BOOL refreshEnable;

@property (nonatomic, assign) BOOL showBackLabel;//是否加载背景label
@property (nonatomic, strong,readonly) UILabel *backLabel;
@property (nonatomic, strong) UIImage *backImage;//无数据时的背景图
@property (nonatomic, strong, readonly) UIImageView *backImageView;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (IETModel *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(UITableViewCell<IETModelBindProtocol> *)cell atIndexPath:(NSIndexPath *)indexPath __attribute__((objc_requires_super));
-(void)configureCell:(UITableViewCell<IETModelBindProtocol> *)cell model:(IETModel *)model atIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (void)registerModelClass:(Class)modelClass mappedCellClass:(Class)cellClass;
- (void)registerModelClass:(Class)modelClass mappedCellClass:(Class)cellClass reuseIdentifer:(NSString *)reuseIdentifer;

- (void)registerModelClass:(Class)modelClass mappedNibName:(NSString *)nibName;
- (void)registerModelClass:(Class)modelClass mappedNibName:(NSString *)nibName reuseIdentifer:(NSString *)reuseIdentifer;

- (void)loadModelCellMap NS_REQUIRES_SUPER;

- (void)beginRefresh;
- (void)endRefresh;

- (void)reloadData;
- (void)fetchData;
- (void)pullRefreshAction;
- (void)upscrollrefreshAction;


- (void)finishFecthDataWithModels:(NSArray *)models since:(NSString *)since;

- (void)goBack;
@end
