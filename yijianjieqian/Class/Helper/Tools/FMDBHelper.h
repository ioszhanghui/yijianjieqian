//
//  FMDBHelper.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/27.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import <Foundation/Foundation.h>
//成功打开
typedef void(^ SuccessOpen)(void);

@interface FMDBHelper : NSObject
/*构建*/
+(instancetype)shareFMDBHelper;
/*打开数据库*/
-(void)openFMDBSqlite:(NSString*)sqlite;
/*插入数据内容*/
-(void)insertFMDBSqlite:(NSArray*)arr Table:(NSString*)table;
/*删除表中的数据*/
 -(void)deleteDataInTable;
//查询数据
-(void)queryTable:(NSString*)table ResultBlock:(void(^)(NSArray* jsonArr))Success;
@end
