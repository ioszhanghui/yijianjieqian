//
//  ZHLoanListViewController.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "ZHLoanListViewController.h"
#import "ZHLoanListCell.h"
#import "LoanListHandler.h"
#import "ZHProductModel.h"

@interface ZHLoanListViewController ()

@end


static NSString * identify = @"loanList";

@implementation ZHLoanListViewController{
    NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentPage=1;
    [self loadData];
    [self configUI];
}

#pragma mark 加载数据
-(void)loadData{
    
    NSDictionary * params=@{
                            @"page_index":@(currentPage),
                            @"page_size":@"10",
                            @"cust_no":@"631"
                            };
    
    [[LoanListHandler new] executeLoanList:params TableView:self.tableView Success:^(NSArray *arrJson, NSInteger code, NSInteger totalPage) {
        
        [self.dataList addObjectsFromArray:arrJson];
        [self.tableView reloadData];
        
    } Fail:^(id Obj) {
        
    }];
}


#pragma mark 布局UI
-(void)configUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHLoanListCell" bundle:nil] forCellReuseIdentifier:identify];
    self.tableView.tableFooterView = [UIView new];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHLoanListCell  * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.productModel = [self.dataList objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

@end
