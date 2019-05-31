//
//  NSObject+JYGetIP.m
//  FpdCarInCube
//
//  Created by WXC on 2017/7/19.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "NSObject+JYGetIP.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NSObject (JYGetIP)

//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    JYLog(@"%@", address);
    return address;
}

@end
