//
//  ZHStringFilterTool.m
//  ZHPay
//
//  Created by admin on 16/8/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ZHStringFilterTool.h"

@implementation ZHStringFilterTool

/*
 @brief 登陆密码
 */
+ (BOOL)filterByLoginPassWord:(NSString *)passWord{
    
    NSString *regex = @"^[A-Za-z0-9]{6,16}$";
//    NSString *regex = @"/(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{6,16}$/";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    return isMatch;
}

/*
 @brief 输入是不是中文
 */
+ (BOOL)filterByUserNameChinese:(NSString *)userName{
    
    NSString * user =[[userName stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"·" withString:@""];
    NSString *regex = @"^[\u4e00-\u9fa5\\.·]{1,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:user];
    return isMatch;

}

/**
 * 手机正则匹配
 */
//#define PHONENO  @"\\b(1)[34578][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b"

+(BOOL)filterByPhoneNumber:(NSString *)phone{

    NSString * predicate = @"^(1[0123456789]{10})|((0[0-9]{2,3}){0,1}([2-9][0-9]{6,7}))$";
    return [ZHStringFilterTool predicateWithObject:predicate evaluate:phone];
}

/**
 匹配手机号是不是正确
 **/
+(BOOL)checkPhoneNumRight:(NSString*)phoneNum{
    
    if (![phoneNum isNullStringAlertString:@"请输入登录手机号"]) {
        return NO;
    }
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    BOOL match =[ZHStringFilterTool predicateWithObject:MOBILE evaluate:phoneNum];
    if (!match) {
        [SVProgressHUD showInfoWithStatus:@"请输入合法的手机号"];
        return YES;
    }
    return YES;
}

/*处理正则判断*/
+(BOOL)predicateWithObject:(NSString*)predicate evaluate:(NSString*)evaluate{
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicate];
    return [regextestmobile evaluateWithObject:evaluate];
}
/**
 检验密码位数
 **/
+(BOOL)checkNumOfPassword:(NSString*)pwd{
    
    NSString *MOBILE = @"^[0-9a-zA-Z_]{6,16}$";
    return [ZHStringFilterTool predicateWithObject:MOBILE evaluate:pwd];
}

/**
 *  字典转换为字符串
 *
 *  @param dic 字典
 *
 *  @return 返回字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark 是否为纯数字
+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark 判断电话号码是不是合法
+(BOOL)isFixedNumError:(NSString*)fixNum{
    
    NSString *pattern = @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [identityCardPredicate evaluateWithObject:fixNum];
}


//邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 保存文件的路径
+(void)saveFilePathWithFileName:(NSString*)fileName File:(NSData*)data FilePath:(void(^)(NSString *))filePath{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //保存路径
    NSString *rootPath = [paths objectAtIndex:0] ;
    //根据路径删除文件或文件夹
    [[NSFileManager defaultManager] removeItemAtPath:rootPath error:nil];
    NSString *fileFullPath = [rootPath  stringByAppendingPathComponent:fileName];
    [data writeToFile:fileFullPath atomically:YES];
    
    NSFileManager * manager = [NSFileManager
                     defaultManager];
    
    if ([manager fileExistsAtPath:fileFullPath]) {
        
        filePath(fileFullPath);
    }

}

#pragma mark base64解密
+(NSData*)Base64DecodeWithCodeString:(NSString*)codeString{
    
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:codeString options:0];
    
    return nsdataFromBase64String;

}

#pragma mark 计算文字的高度
+(CGSize)computeTextSizeHeight:(NSString*)text Range:(CGSize)size FontSize:(UIFont*)font{
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark 设置文字的行间距
+(NSAttributedString*)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font LineHeight:(CGFloat)lineHight TextAlignment:(NSTextAlignment)textAlign{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = textAlign;
    paraStyle.lineSpacing = lineHight; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    return attributeStr;
}

+(NSMutableAttributedString*)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font LineHeight:(CGFloat)lineHight TextAlignment:(NSTextAlignment)textAlign RangeColor:(UIColor*)color Range:(NSRange)range{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = textAlign;
    paraStyle.lineSpacing = lineHight; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,
                          };
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    
    return attributeStr;
}

+(NSMutableAttributedString*)setLabelSpacewithValue:(NSString*)str withNumberFont:(UIFont*)font Range:(NSRange)range1 TextFont:(UIFont*)textFont TextRange:(NSRange)range2{
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:@{NSFontAttributeName:font} range:range1];
     [attributeStr addAttributes:@{NSFontAttributeName:textFont} range:range2];
    return attributeStr;
}


#pragma mark 计算有行间距的高度
+(CGSize)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font LineHeight:(CGFloat)lineHight  Range:(CGSize)size TextAlignment:(NSTextAlignment)textAlign{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = textAlign;
    paraStyle.lineSpacing = lineHight;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return textSize;
}

#pragma mark 如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType containsString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType containsString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType containsString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}


@end
