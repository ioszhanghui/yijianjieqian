//
//  FMDBHelper.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/27.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "FMDBHelper.h"
#import "FMDatabase.h"

@interface FMDBHelper()

/*FMDatabase数据库*/
@property(nonatomic,strong)FMDatabase * fmDataBase;
@end

// 获取Documents目录路径
#define KDocumentPath ((NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);

@implementation FMDBHelper

-(instancetype)init{
    if (self=[super init]) {
        
        //数据库的路径
        NSString * docPath = KDocumentPath;
        NSString * fmdbPath =[docPath stringByAppendingPathComponent:@"Loan_List.sqlite"];
        self.fmDataBase = [FMDatabase databaseWithPath:fmdbPath];
        NSLog(@"%@",fmdbPath);
    }
    return self;
}

/*构建*/
+(instancetype)shareFMDBHelper{
    static FMDBHelper * helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [FMDBHelper new];
    });
    return helper;
}

/*打开数据库的表*/
-(void)openFMDBSqlite:(NSString*)table  Success:(SuccessOpen)success{

    if ([self.fmDataBase open]) {
        //打开成功
        //判断表是不是存在
        if ([self isTableOK:table]) {
            success();//回调
        }
        
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (id integer PRIMARY KEY AUTOINCREMENT,product_apply_info varchar(255),product_join_way varchar(255),product_service_phone varchar(255),product_name varchar(255),term varchar(255),product_month_rate varchar(255),product_state varchar(255),product_flag varchar(255),product_advantage varchar(255),product_join_url varchar(255),product_min_amount varchar(255),product_max_day varchar(255),product_icon_path varchar(255),product_detail varchar(255),product_max_amount varchar(255))",table];
        
        // 创建数据表
        BOOL result = [self.fmDataBase executeUpdate:sql];
        if (result) {
            //表创建成功
            success();
        }else{
            //表创建失败
        }
    }else{
        //打开失败
    }
}

/*查找某个数据库里面 是否含有某个表*/
- (BOOL)isTableOK:(NSString *)tableName{
    
    FMResultSet *rs = [self.fmDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]){
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count){
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

/*插入数据内容*/
-(void)insertFMDBSqlite:(NSArray*)arr Table:(NSString*)table{
    
    @synchronized(self){
        //对表的处理
        [self openFMDBSqlite:table Success:^{
            
            dispatch_queue_t queue = dispatch_queue_create("loanList", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^{
                //遍历添加
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@(id,product_service_phone,product_name,product_icon_path,product_apply_info,product_month_rate,product_join_url,product_detail,product_max_amount) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@');",table,[@(idx) stringValue],obj[@"product_service_phone"],obj[@"product_name"],obj[@"product_icon_path"],obj[@"product_apply_info"],obj[@"product_month_rate"],obj[@"product_join_url"],obj[@"product_detail"],obj[@"product_max_amount"]];
                    NSLog(@"sql****%@",sql);
                    //,obj[@"product_service_phone"],obj[@"product_name"],obj[@"product_icon_path"]
                  BOOL success = [self.fmDataBase executeUpdate:sql];
                    if (success) {
                        NSLog(@"插入成功");
                    }else{
                         NSLog(@"插入失败");
                    }
                }];
            });
        }];
    }
}

//删除数据
 -(void)deleteDataInTable{
    [self.fmDataBase executeUpdate:@"DROP TABLE IF EXISTS LoanList;"];
}

//查询表中的数据
-(void)queryTable:(NSString*)table ResultBlock:(void(^)(NSArray* jsonArr))Success;{
    
    @synchronized(self){
        NSString * sql =[NSString stringWithFormat:@"SELECT * FROM %@",table];
        FMResultSet * resultSet = [self.fmDataBase executeQuery:sql];
        // 2.遍历结果
        NSMutableArray * results = [NSMutableArray array];
        while ([resultSet next]) {
            //取出Data数据
            NSString * product_name = [resultSet stringForColumn:@"product_name"];//product_name
            NSString * product_apply_info = [resultSet stringForColumn:@"product_apply_info"];//product_apply_info
            NSString * product_join_url = [resultSet stringForColumn:@"product_join_url"];
            NSString * product_max_amount = [resultSet stringForColumn:@"product_max_amount"];
            NSString * product_icon_path = [resultSet stringForColumn:@"product_icon_path"];
            NSString * product_month_rate = [resultSet stringForColumn:@"product_month_rate"];
            NSDictionary * jsonDic = @{
                                   @"product_name":product_name,
                                   @"product_apply_info":product_apply_info,
                                   @"product_join_url":product_join_url,
                                   @"product_max_amount":product_max_amount,
                                   @"product_icon_path":product_icon_path,
                                   @"product_month_rate":product_month_rate
                                };
            
            [results addObject:jsonDic];
        }
        //回调查询的 结果
        Success(results);
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//转化成字符串
+ (NSString *)jsonStringWithObject:(id)jsonObject{
    // 将字典或者数组转化为JSON串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return nil;
    }
}

@end
