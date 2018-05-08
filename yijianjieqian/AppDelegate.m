//
//  AppDelegate.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/21.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHLogInViewController.h"
#import "AppDelegate+Category.h"
#import "ZHLoanListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
   ZHLoanListViewController * VC = [[ZHLoanListViewController alloc]init];
    self.window.rootViewController = VC;
    
    [self configIQKeyboardManager];
    [self configMBProgressUD];
    
    return YES;
}



@end
