//
//  UserTool.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User:NSObject<NSCoding>
/** 用户名 */
@property (copy, nonatomic)  NSString *realname;
/**身份证号码 */
@property (copy, nonatomic)  NSString *idcardno;
/** 用户ID */
@property(nonatomic , copy)NSString *custno;
/** 用户电话账户 */
@property(nonatomic , copy)NSString *phoneno;
/**实名认证*/
@property(nonatomic , copy)NSString * realname_state;
/*单位信息*/
@property(nonatomic,copy)NSString * credit_state;
/**身份证认证状态*/
@property(nonatomic , copy)NSString * auth_state;
/**基本信息状态*/
@property(nonatomic , copy)NSString * base_state;
/*借款金额*/
@property(nonatomic,copy)NSString * assess_money;
/*贷款记录申请条数*/
@property(nonatomic,copy)NSString * apply_info_count;
@end

@class User;
@interface UserTool : NSObject

/*保存用户数据*/
+(void)saveUserInfo:(NSDictionary*)info;
/*获取用户数据信息*/
+(User*)getUserInfo;

@end
