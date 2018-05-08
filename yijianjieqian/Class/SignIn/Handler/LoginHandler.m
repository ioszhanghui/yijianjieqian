//
//  LoginHandler.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "LoginHandler.h"

@implementation LoginHandler

/**
 获取验证码
 @param succes 成功回调
 @param fail 失败回调
 */
+(void)executeGetVerifyCodePhoneNum:(NSString*)phoneNum Success:(Success)succes Fail:(Failed)fail;{
    
    //2.获取验证码
    NSString* str = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"我们将会发送验证码到手机", nil),phoneNum];
    
    [AlertViewTool showAlertView:nil title:@"确认手机号码" message:str cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        //1.请求
        NSDictionary *params = @{
                                 @"phoneNum" : phoneNum
                                 };
        [HttpTool PostWithPath:@"/YJJQWebService/GetPhoneCode.spring" params:params success:^(id json) {
            
            if ([json[@"code"] isEqualToString:@"200"]) {

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                });
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

+(void)executeLoginWithParam:(NSDictionary*)param Success:(Success)success Fail:(Failed)fail{
    [HttpTool postWithPath:@"/YJJQWebService/Login.spring" params:param success:^(id json) {
        if ([json[@"code"] isEqualToString:@"200"]) {
            NSLog(@"登录的****%@",json);
            //保存用户信息data
            [UserTool saveUserInfo:[json objectForKey:@"data"]];
            success(json);
        }
    } failure:^(NSError *error) {
        fail(error);
        [SVProgressHUD showErrorWithStatus:@"登录 失败"];
    }];
    
}
@end
