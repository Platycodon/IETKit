//
//  IETFormListController.m
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/17.
//  Copyright © 2017年 lunan. All rights reserved.
//

#import "IETFormListController.h"

#import "IETModelToFormProtocol.h"

@implementation IETFormListController

- (instancetype)init {
    if (self = [super init]) {
        self.refreshEnable = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setFormModel:(IETModel<IETModelToFormProtocol> *)formModel {
    _formModel = formModel;
    self.tableModels = [_formModel itemsFormedFromModel].mutableCopy;
    [self.tableModels enumerateObjectsUsingBlock:^(IETModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IETFormItem *item = (IETFormItem *)obj;
        item.delegate = self;
        [self configureItem:item forKey:item.bindingKey];
    }];
}

- (void)configureItem:(IETFormItem *)item forKey:(NSString *)key {
    //子类实现
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)applyFormToModel {
    [self.tableModels enumerateObjectsUsingBlock:^(IETModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IETFormItem *item = (IETFormItem *)obj;
        [item updateValueToModel];
    }];
}

- (IETFormItem *)itemForKey:(NSString *)key{
    __block IETFormItem *item;
    [_formModel.itemsFormedFromModel enumerateObjectsUsingBlock:^(IETFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bindingKey isEqualToString:key]) {
            item = obj;
            *stop = YES;
        }
    }];
    return item;
}

- (IETFormItem *)checkMandatory {
    for (IETFormItem *item in self.formModel.itemsFormedFromModel) {
        if (item.isMandatory && (item.value == nil ||  [item.value length]==0)) {
            return item;
        }
    }
    return nil;
}

@end
