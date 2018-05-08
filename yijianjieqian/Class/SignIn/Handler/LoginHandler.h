//
//  LoginHandler.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "BaseHandler.h"

@interface LoginHandler : BaseHandler

/**
 获取验证码
 @param succes 成功回调
 @param fail 失败回调
 */
+(void)executeGetVerifyCodePhoneNum:(NSString*)phoneNum Success:(Success)succes Fail:(Failed)fail;

/**
 登录

 @param param 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+(void)executeLoginWithParam:(NSDictionary*)param Success:(Success)success Fail:(Failed)fail;

@end
