//
//  NSString+Null.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "NSString+Null.h"

@implementation NSString (Null)

/*提示内容*/
-(BOOL)isNullStringAlertString:(NSString*)alertStr{
    //判断是不是为空
    if (NULLString(self)) {
         [SVProgressHUD showInfoWithStatus:alertStr];
        return NO;
    }
    return YES;
}

@end
