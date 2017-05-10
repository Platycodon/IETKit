//
//  IETMultilevelTableViewController.m
//  IETKitTest
//
//  Created by 陆楠 on 2017/5/10.
//  Copyright © 2017年 lunan. All rights reserved.
//

#import "IETMultilevelTableViewController.h"
#import "IETMultilevelTableNodeProtocol.h"

@interface IETMultilevelTableViewController ()

@end

@implementation IETMultilevelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IETModel *model = [self modelAtIndexPath:indexPath];
    NSAssert([model conformsToProtocol:@protocol(IETMultilevelTableNodeProtocol)], @"model must conforms to protocol IETMultilevelTableNodeProtocol");
    IETModel<IETMultilevelTableNodeProtocol> *node = (IETModel<IETMultilevelTableNodeProtocol> *)model;
    if (node.isLeaf == NO) {
        if (node.isOpen == NO) {//展开
            node.isOpen = YES;
            NSMutableArray *indexPaths = [NSMutableArray new];
            NSArray *nodes = [self recursiveNodesShouldOperateInNode:node];
            for (int i = 1; i<=nodes.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section]];
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, nodes.count)];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableModels insertObjects:nodes atIndexes:indexSet];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }else{//合上
            NSMutableArray *indexPaths = [NSMutableArray new];
            NSArray *nodes = [self recursiveNodesShouldOperateInNode:node];
            for (IETModel *sub in nodes) {
                for (int i = 0;i<self.tableModels.count;i++) {
                    IETModel *tableModel = self.tableModels[i];
                    if (sub == tableModel) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                        break;
                    }
                }
            }
            node.isOpen = NO;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableModels removeObjectsInArray:nodes];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (NSArray *)recursiveNodesShouldOperateInNode:(IETModel<IETMultilevelTableNodeProtocol> *)node{
    NSMutableArray *arr = [NSMutableArray new];
    if (node.isOpen == YES) {
        for (IETModel<IETMultilevelTableNodeProtocol> *sub in node.subNodes) {
            [arr addObject:sub];
            [arr addObjectsFromArray:[self recursiveNodesShouldOperateInNode:sub]];
        }
    }else{
        return nil;
    }
    return arr;
}

@end





