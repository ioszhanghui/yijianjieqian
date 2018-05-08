//
//  LoanListHandler.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "LoanListHandler.h"
#import "ZHProductModel.h"
#import "FMDBHelper.h"
#import "NetWorkStatus.h"

@interface LoanListHandler()

@end

@implementation LoanListHandler

/**
 贷款列表请求
 
 @param param 请求的参数
 @param success 成功
 @param fail 失败
 */
-(void)executeLoanList:(NSDictionary*)param TableView:(UITableView*)tableView Success:(LoanListSuccess)success Fail:(Failed)fail{
    
    if ( ![NetWorkStatus isFi]) {
        //无网络
    }
    //数据
    NSMutableArray * arrList = [NSMutableArray array];
    //当前页码
   __block NSInteger totalPage;
    //Code码
    __block NSInteger code;
    
    [HttpTool PostWithPath:@"/YJJQWebService/GetLoanList.spring" params:param success:^(id json) {

        NSLog(@"贷款记录****%@",json);
        
        [[FMDBHelper  shareFMDBHelper] insertFMDBSqlite:[[json objectForKey:@"data"] objectForKey:@"list"] Table:@"Loan"];
        
        [[FMDBHelper shareFMDBHelper]queryTable:@"Loan" ResultBlock:^(NSArray *jsonArr) {
            
        }];
        
        code = [[json objectForKey:@"code"]integerValue];
        if (code == 200) {

            totalPage = [[[json objectForKey:@"data"] objectForKey:@"total_page"] integerValue];
            [arrList addObjectsFromArray:[ZHProductModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]]];
            success(arrList,totalPage,code);
        } else if([[json objectForKey:@"code"]isEqualToString:@"400"]){
        }
        
    } failure:^(NSError *error) {
        [self dismissTableRefresh:tableView AlertTitle:@"加载失败"];
        fail(error);
    }];

}

@end
