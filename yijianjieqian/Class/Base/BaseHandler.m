//
//  BaseHandler.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/21.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "BaseHandler.h"

@implementation BaseHandler

/*成功之后 结束请求刷新*/
-(void)dismissTableRefresh:(UITableView*)tableView{
    
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}

/*失败之后的 结束刷新*/
-(void)dismissTableRefresh:(UITableView*)tableView AlertTitle:(NSString*)title{
    
    [self dismissTableRefresh:tableView];
    [SVProgressHUD showInfoWithStatus:title];
}

@end
