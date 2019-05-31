//
//  OAuthAccountTool.h
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthAccount.h"

@interface OAuthAccountTool : NSObject


/**
 *  存储账号信息
 *
 *  @param dict 账号模型
 */
+ (void)saveAccount:(NSDictionary *)dict;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (OAuthAccount *)account;


/**
 删除Token
 */
+ (void)removeAccount;

/**
 获取头部信息
 */
+ (NSDictionary *)getHeaderDic;

/**
 判断是否过期
 */
//+ (BOOL)isAccountAccess_tokenOverdue;


/**
 保存登录状态
 */
+ (void)saveIsLogin;


/**
 是否登录
 */
+ (BOOL)isLogin;

/**
 移除登录状态
 */
+ (void)removeIsLogin;

@end
