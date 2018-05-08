//
//  ZHLogInViewController.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/21.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "ZHLogInViewController.h"
#import "LoginHandler.h"
#import "LoginSuccessView.h"

@interface ZHLogInViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeSendBtn;

@end

@implementation ZHLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark 布局UI
-(void)configUI{
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate=self;
    [self.codeTextField addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark 登录方法
- (void)loginBtnClick {
    
    if (![ZHStringFilterTool checkPhoneNumRight:self.phoneTextField.text]||![self.codeTextField.text isNullStringAlertString:@"请输入验证码"]) {
        return;
    }
    
    if (self.codeTextField.text.length==6) {
        //登录
        NSDictionary *params = @{
                                 @"phone_num":self.phoneTextField.text,
                                 @"newCode":self.codeTextField.text
                                 };
        [LoginHandler executeLoginWithParam:params Success:^(id Obj) {
            
            if ([[UserTool getUserInfo].realname_state isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [LoginSuccessView shareLoginSuccessViewWithFrame:[UIScreen mainScreen].bounds Type:LogInSuccess  CancelAction:^{
                    //取消
                    [self.navigationController popViewControllerAnimated:YES];
                } SureAction:^{
                    
//                    ZHCompleteViewController * VC =[ZHCompleteViewController new];
//                    VC.type=LoginChannel;
//                    [self.navigationController pushViewController:VC animated:YES];
                }];
            }
        } Fail:^(id Obj) {
            
        }];
    }
}

#pragma mark 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    //账号
    if (textField == self.phoneTextField) {
        if (textField.text.length > 10) return NO;
    }
    //验证码
    if (textField == self.codeTextField) {
        if (textField.text.length > 5) return NO;
    }
    return YES;
}

- (IBAction)codeSendAvtion:(id)sender {
    
    if (![ZHStringFilterTool checkPhoneNumRight:self.phoneTextField.text]) {
        return;
    }
    [_codeSendBtn startWithTime:60 title:@"发送验证码" countDownTitle:@"s" mainColor:UIColorWithRGB(0x1869ff, 1.0) countColor:UIColorWithRGB(0x1869ff, 1.0)];
    
    [LoginHandler executeGetVerifyCodePhoneNum:self.phoneTextField.text Success:^(id Obj) {
        NSLog(@"验证码发送成功");
    } Fail:^(id Obj) {
        
    }];
}

@end
