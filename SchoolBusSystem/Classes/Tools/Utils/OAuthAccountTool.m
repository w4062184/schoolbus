//
//  OAuthAccountTool.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "OAuthAccountTool.h"

@implementation OAuthAccountTool

/**
 *  存储账号信息
 *
 */
+ (void)saveAccount:(NSDictionary *)dict
{
    [OAuthAccount accountWithDict:dict];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    JYWriteToPlist(data, @"userData");
}


/**
 *  返回账号信息
 */
+ (OAuthAccount *)account
{
    // 加载plist文件
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userData.plist"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return [OAuthAccount accountWithDict:dict];
    }
    return nil;
}

+ (void)removeAccount
{
    NSFileManager *fmanager=[NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userData.plist"];
    [fmanager removeItemAtPath:filePath error:nil];
}

// 认证时的头部信息
+ (NSDictionary *)getHeaderDic
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    if ([OAuthAccount sharedJYOAuthAccount].token.length) {
        [headerDic safeSetObject:[OAuthAccount sharedJYOAuthAccount].token forKey:@"token"];
        return headerDic;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"token为空值"];
    }
    
    return nil;
}


/**
 保存登录状态
 */
+ (void)saveIsLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISLOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 是否登录
 */
+ (BOOL)isLogin
{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
}

/**
 移除登录状态
 */
+ (void)removeIsLogin
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ISLOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
