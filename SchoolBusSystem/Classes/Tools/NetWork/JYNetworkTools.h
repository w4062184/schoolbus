//
//  JYNetworkTools.h
//  FpdCarInCube
//
//  Created by WXC on 2017/4/10.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYNetworkTools : NSObject


+ (void)requestWithEntity:(JYBaseEntity *)entity needHud:(BOOL)isNeedHud needDismiss:(BOOL)isNeedDismiss success:(void(^)(id responseObject))success failed:(void(^)(NSError *error))failure;
@end
