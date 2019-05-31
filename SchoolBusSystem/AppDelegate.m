//
//  AppDelegate.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/1/23.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AudioToolbox/AudioToolbox.h>
#import "JYNewfeatureViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // SVProgressHUD 设置，设置提示的最短时间
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    // [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    
    // JPush推送
    [self registerForRemoteNotificationWith:launchOptions];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    NSString *key = @"CFBundleShortVersionString";
//    // 上一次的使用版本（存储在沙盒中的版本号）
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    // 当前软件的版本号（从Info.plist中获得）
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        [self.window switchRootViewController];
//    } else { // 这次打开的版本和上一次不一样，显示新特性
//        self.window.rootViewController = [[JYNewfeatureViewController alloc] init];
//        // 将当前的版本号存进沙盒
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - APNS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    JYLog(@"deviceToken:%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
//    NSString *reid = [[[[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
//    [[NSUserDefaults standardUserDefaults]setObject:reid forKey:@"registrationId"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    JYLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support 通知栏收到就调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 播放震动
    AudioServicesPlaySystemSound(1007);
}

// iOS 10 Support 点击通知时
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
//    id vc = self.window.rootViewController;
//    if ([vc isKindOfClass:[JYTabBarController class]]) {
//        JYTabBarController *tabVc = (JYTabBarController *)vc;
//        [tabVc setAPNsInfo:userInfo];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    id vc = self.window.rootViewController;
//    if ([vc isKindOfClass:[JYTabBarController class]]) {
//        JYTabBarController *tabVc = (JYTabBarController *)vc;
//        [tabVc setAPNsInfo:userInfo];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
//    id vc = self.window.rootViewController;
//    if ([vc isKindOfClass:[JYTabBarController class]]) {
//        JYTabBarController *tabVc = (JYTabBarController *)vc;
//        [tabVc setAPNsInfo:userInfo];
//    }
}



#pragma mark - custom method
// 注册推送消息，包含短消息、声音和应用程序图标标记
- (void)registerForRemoteNotificationWith:(NSDictionary *)launchOptions
{
    
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    
    
    //
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //    //Required
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    //        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    //        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //    }
    //    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //        //可以添加自定义categories
    //        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
    //                                                          UIUserNotificationTypeSound |
    //                                                          UIUserNotificationTypeAlert)
    //                                              categories:nil];
    //    }
    //    else {
    //        //categories 必须为nil
    //        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
    //                                                          UIRemoteNotificationTypeSound |
    //                                                          UIRemoteNotificationTypeAlert)
    //                                              categories:nil];
    //    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    NSString *appKey = nil;
    NSString *channel = nil;
    BOOL isProduction ;
#ifdef DEBUG
    appKey = @"65f73da9e67f614b0742a432";
    channel = @"App Store";
    isProduction = NO;
#else
    appKey = @"65f73da9e67f614b0742a432";
    channel = @"App Store";
    isProduction = YES;
#endif
    
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"registrationId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

@end
