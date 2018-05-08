//
//  UserTool.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "UserTool.h"

#define KFilePath     [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"user.user"]

@implementation User
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.custno forKey:@"custno"];
    [coder encodeObject:self.idcardno forKey:@"idcardno"];
    [coder encodeObject:self.phoneno forKey:@"phoneno"];
    [coder encodeObject:self.auth_state forKey:@"auth_state"];
    [coder encodeObject:self.realname forKey:@"realname"];
    [coder encodeObject:self.realname_state forKey:@"realname_state"];
    [coder encodeObject:self.credit_state forKey:@"credit_state"];
    [coder encodeObject:self.base_state forKey:@"base_state"];
    [coder encodeObject:self.assess_money forKey:@"assess_money"];
    [coder encodeObject:self.apply_info_count forKey:@"apply_info_count"];
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self=[super init]) {
        _custno = [coder decodeObjectForKey:@"custno"];
        _phoneno = [coder decodeObjectForKey:@"phoneno"];
        self.custno = [coder decodeObjectForKey:@"custno"];
        self.idcardno = [coder decodeObjectForKey:@"idcardno"];
        self.phoneno = [coder decodeObjectForKey:@"phoneno"];
        self.auth_state = [coder decodeObjectForKey:@"auth_state"];
        self.realname = [coder decodeObjectForKey:@"realname"];
        self.realname_state = [coder decodeObjectForKey:@"realname_state"];
        self.credit_state = [coder decodeObjectForKey:@"credit_state"];
        self.base_state = [coder decodeObjectForKey:@"base_state"];
        self.assess_money = [coder decodeObjectForKey:@"assess_money"];
        self.apply_info_count = [coder decodeObjectForKey:@"apply_info_count"];
    }
    return self;
}

@end

@implementation UserTool

/*保存用户数据*/
+(void)saveUserInfo:(NSDictionary*)info{
    
    User * user =[User mj_objectWithKeyValues:info];
    [NSKeyedArchiver archiveRootObject:user toFile:KFilePath];
}

/*获取用户数据信息*/
+(User*)getUserInfo{
    
   User * user = [NSKeyedUnarchiver unarchiveObjectWithFile:KFilePath];
    
    return user;
}

@end
