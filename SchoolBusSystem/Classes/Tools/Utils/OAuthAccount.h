//
//  OAuthAccount.h
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthAccount : NSObject

/** <#variate#> */
@property (nonatomic, copy) NSString *token;
/** <#variate#> */
@property (nonatomic, copy) NSString *userid;

/** 上车点 */
@property (nonatomic, assign) CLLocationCoordinate2D pointcoordinate;
/** 点地址 */
@property (nonatomic, strong) NSString *pointAddress;

+ (instancetype)accountWithDict:(NSDictionary *)dict;


// 单例
HMSingletonH(JYOAuthAccount)


@end
