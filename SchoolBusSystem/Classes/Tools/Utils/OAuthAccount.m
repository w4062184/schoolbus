//
//  OAuthAccount.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "OAuthAccount.h"

@implementation OAuthAccount

// 单例
HMSingletonM(OAuthAccount)

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    OAuthAccount *account = [[self alloc] init];
    NSMutableDictionary *dic = [dict[@"data"][0] mutableCopy];
    account.token = dic[@"token"];
    account.userid = dic[@"userid"];
    return account;
}

@end
