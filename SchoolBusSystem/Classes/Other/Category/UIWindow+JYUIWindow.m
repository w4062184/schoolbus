//
//  UIWindow+JYUIWindow.m
//  FpdCarInCube
//
//  Created by WXC on 2017/4/10.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "UIWindow+JYUIWindow.h"
#import "JYLoginController.h"
#import "JYNavigationController.h"
#import "HomeController.h"

@implementation UIWindow (JYUIWindow)

- (void)switchRootViewController
{
    JYLogFunc
    if ([OAuthAccountTool isLogin] && [OAuthAccountTool account]) { // 之前已经登录成功过
        // 设置根控制器
        self.rootViewController = [[JYNavigationController alloc] initWithRootViewController:[[HomeController alloc] init]];
    } else {
        self.rootViewController = [[JYNavigationController alloc] initWithRootViewController:[[JYLoginController alloc] init]];
    }
}

@end
