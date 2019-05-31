//
//  JYBaseEntity.h
//  FpdCarInCube
//
//  Created by WXC on 2017/4/11.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JYBaseEntity : NSObject
@property (nonatomic, assign) RequestType reqType;     // 请求类型

/** <#variate#> */
@property (nonatomic, copy) NSString *sign;
/** <#variate#> */
@property (nonatomic, copy) NSString *content;


/** <#variate#> */
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
- (instancetype)initWithReqType:(RequestType)type;

- (NSDictionary *)package:(RequestType)type;

@end
