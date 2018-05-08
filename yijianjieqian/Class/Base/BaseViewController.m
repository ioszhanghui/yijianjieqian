//
//  BaseViewController.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/21.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


@end
