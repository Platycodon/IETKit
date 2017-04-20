//
//  IETModelTableViewController.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModelTableViewController.h"
#import "IETModel.h"
#import "IETSection.h"
#import "MJRefresh.h"
#import "UIView+IETAdd.h"
#import "NSArray+IETAdd.h"
#import "NSDictionary+IETAdd.h"
#import "IETTableSeparatorCell.h"

@interface IETTableFooterView : UIView
@property (nonatomic, assign) NSInteger state;//0 空闲，即无任何表示 1加载更多中 2无更多
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end
@implementation IETTableFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_indicator];
        _label = [UILabel new];
        _label.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        _label.font = [UIFont systemFontOfSize:12];
        [self addSubview:_label];
    }
    return self;
}
- (void)setState:(NSInteger)state {
    _state = state;
    if (state == 0) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _label.text = @"即将加载更多内容";
        [_label sizeToFit];
    }else if (state == 1){
        [_indicator startAnimating];
        _indicator.hidden = NO;
        _label.text = @"正在加载中...";
        [_label sizeToFit];
    }else if (state == 2){
        [_indicator startAnimating];
        _indicator.hidden = YES;
        _label.text = @"暂无更多内容";
        [_label sizeToFit];
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _label.centerX = self.width/2;
    _indicator.right = _label.left-4;
    _indicator.centerY = _label.centerY = self.height/2;
}
@end

@interface IETModelTableViewController ()
{
    BOOL _hasMore;
}
@property (nonatomic, strong) IETTableView *tableView;
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) IETTableFooterView *footerView;
@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation IETModelTableViewController
{
    NSMutableDictionary *_modelCellClassMap;
    NSMutableDictionary *_modelNibNameClassMap;
    NSMutableDictionary *_modelReuseIdentiferMap;
    UITableViewStyle _tableViewStyle;
}

-(NSMutableArray<IETModel *> *)tableModels
{
    if (_tableModels == nil) {
        _tableModels = [NSMutableArray new];
    }
    return _tableModels;
}

-(instancetype)init
{
    if (self = [super init]) {
        _tableViewStyle = UITableViewStylePlain;
        _modelCellClassMap = [NSMutableDictionary new];
        _modelReuseIdentiferMap = [NSMutableDictionary new];
        _modelNibNameClassMap = [NSMutableDictionary new];
        _refreshEnable = NO;
        _since = @"0";
        _showBackLabel = YES;
        _hasMore = YES;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init]) {
        _tableViewStyle = style;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    _tableView = [[IETTableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    if (_refreshEnable) {
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.since = @"0";
            [weakSelf pullRefreshAction];
        }];
        _footerView = [[IETTableFooterView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 25)];
        _tableView.tableFooterView = _footerView;
    }
    [self.view addSubview:_tableView];
    
    _backImageView = [UIImageView new];
    _backImageView.centerX = self.view.width/2;
    _backImageView.top = 80;
    [self.view addSubview:_backImageView];
    _backImageView.hidden = YES;
    
    _backLabel = [UILabel new];
    _backLabel.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    _backLabel.font = [UIFont systemFontOfSize:13];
    _backLabel.text = @"暂无相关结果";
    _backLabel.frame = CGRectMake(50, _backImageView.bottom+20, self.view.width-100, 50);
    _backLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:_backLabel belowSubview:_tableView];
    _backLabel.hidden = YES;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadModelCellMap];
}

- (void)setRefreshEnable:(BOOL)refreshEnable
{
    _refreshEnable = refreshEnable;
}

- (void)setBackImage:(UIImage *)backImage {
    _backImage = backImage;
    _backImageView.image = backImage;
    
    [_backImageView sizeToFit];
    _backImageView.centerX = self.view.width/2;
    _backLabel.top = _backImageView.bottom+20;
}

#pragma mark - user APIs

- (void)beginRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
}

-(void)loadModelCellMap
{
    [self registerModelClass:[IETTableSeparator class] mappedCellClass:[IETTableSeparatorCell class]];
}

-(void)configureCell:(UITableViewCell<IETModelBindProtocol> *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)configureCell:(UITableViewCell<IETModelBindProtocol> *)cell model:(IETModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = YES;
    [self configureCell:cell atIndexPath:indexPath];
}

-(void)registerModelClass:(Class)modelClass mappedCellClass:(Class)cellClass
{
    [self registerModelClass:modelClass mappedCellClass:cellClass reuseIdentifer:NSStringFromClass(cellClass)];
}

-(void)registerModelClass:(nonnull Class)modelClass mappedCellClass:(nonnull Class)cellClass reuseIdentifer:(nonnull NSString *)reuseIdentifer
{
    if (![modelClass isSubclassOfClass:[IETModel class]] || ![cellClass isSubclassOfClass:[UITableViewCell class]] ||
        ![cellClass conformsToProtocol:@protocol(IETModelBindProtocol)] || reuseIdentifer.length == 0) {
        NSLog(@"failed to register,illegal arguments...");
        return;
    }
    NSString *key = NSStringFromClass(modelClass);
    [_modelCellClassMap setObject:NSStringFromClass(cellClass) forKey:key];
    [_modelReuseIdentiferMap setObject:reuseIdentifer forKey:key];
    [_tableView registerClass:cellClass forCellReuseIdentifier:reuseIdentifer];
}

- (void)registerModelClass:(Class)modelClass mappedNibName:(NSString *)nibName
{
    [self registerModelClass:modelClass mappedNibName:nibName reuseIdentifer:nibName];
}

-(void)registerModelClass:(Class)modelClass mappedNibName:(NSString *)nibName reuseIdentifer:(NSString *)reuseIdentifer
{
    NSString *key = NSStringFromClass(modelClass);
    [_modelNibNameClassMap setObject:nibName forKey:key];
    [_modelReuseIdentiferMap setObject:reuseIdentifer forKey:key];
    [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:reuseIdentifer];
}

-(IETModel *)modelAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_tableModels objectOrNilAtIndex:0] isKindOfClass:[IETSection class]])
    {
        return [((IETSection *)[_tableModels objectOrNilAtIndex:indexPath.section]).models objectOrNilAtIndex:indexPath.row];
    }else{
        return [_tableModels objectOrNilAtIndex:indexPath.row];
    }
}

- (void)removeModelAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_tableModels objectOrNilAtIndex:0] isKindOfClass:[IETSection class]])
    {
        [[[self.tableModels objectOrNilAtIndex:indexPath.section] models] removeObjectAtIndex:indexPath.row];
    }else{
        [self.tableModels removeObjectAtIndex:indexPath.row];
    }
}

- (void)reloadData {
    [self.tableView reloadData];
    if (self.tableModels.count == 0 && _showBackLabel) {
        _backLabel.hidden = NO;
        _backImageView.hidden = NO;
    }else{
        _backLabel.hidden = YES;
        _backImageView.hidden = YES;
    }
    if (self.tableModels.count == 0) {
        _footerView.hidden = YES;
    }else{
        _footerView.hidden = NO;
    }
    _footerView.state = 0;
}

- (void)fetchData
{
    
}

- (void)pullRefreshAction
{
    [self fetchData];
}

-(void)upscrollrefreshAction
{
    [self fetchData];
}

- (void)finishFecthDataWithModels:(NSArray *)models since:(NSString *)since hasMore:(BOOL)hasMore
{
    _hasMore = hasMore;
    //目前仅支持不带section的格式
    if (self.tableModels.count == 0 || ![self.tableModels[0] isKindOfClass:[IETSection class]]) {
        if ([self.since isEqualToString:@"0"]) {
            [self.tableModels removeAllObjects];
        }
        self.since = since;
        [self endRefresh];
        [self.tableModels addObjectsFromArray:models];
        [self reloadData];
    }
}

#pragma mark - tableview delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableModels.count==0) {
        return 0;
    }else if ([[_tableModels objectOrNilAtIndex:0] isKindOfClass:[IETSection class]])
    {
        return _tableModels.count;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableModels.count==0) {
        return 0;
    }else if ([[_tableModels objectOrNilAtIndex:0] isKindOfClass:[IETSection class]])
    {
        return ((IETSection *)[_tableModels objectOrNilAtIndex:section]).models.count;
    }else{
        return _tableModels.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IETModel *model = [self modelAtIndexPath:indexPath];
    NSString *reuseIdentifer = [_modelReuseIdentiferMap objectOrNilForKey:NSStringFromClass([model class])];
    NSAssert(reuseIdentifer, @"no class was registered for model");
    UITableViewCell<IETModelBindProtocol> *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    cell.model = model;
    [self configureCell:cell model:model atIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IETModel *model = [self modelAtIndexPath:indexPath];
    NSString *reuseIdentifer = [_modelReuseIdentiferMap objectOrNilForKey:NSStringFromClass([model class])];
    return [tableView fd_heightForCellWithIdentifier:reuseIdentifer configuration:^(id<IETModelBindProtocol> cell) {
        cell.model = model;
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_refreshEnable) {
        if (self.tableModels.count>0 && _hasMore && ![_since isEqualToString:@"0"]) {
            if (![self.tableModels[0] isKindOfClass:[IETSection class]]) {
                if (indexPath.row == self.tableModels.count - 1) {
                    //加载更多
                    _footerView.state = 1;
                    [self upscrollrefreshAction];
                }
            }else{
                //带section的刷新比较麻烦，后期用到的时候再补充吧，需要后台配合
            }
        }else if (_hasMore == NO){
            _footerView.state = 2;
        }
    }
}
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end










