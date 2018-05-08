//
//  LoanListHandler.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "BaseHandler.h"
#import "ZHLoanListViewController.h"

typedef void(^ LoanListSuccess)(NSArray * arrJson,NSInteger code,NSInteger totalPage);

@interface LoanListHandler : BaseHandler


/**
贷款列表请求

 @param param 请求的参数
 @param success 成功
 @param fail 失败
 */
-(void)executeLoanList:(NSDictionary*)param TableView:(UITableView*)tableView Success:(LoanListSuccess)success Fail:(Failed)fail;

@end
