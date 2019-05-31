//
//  JYBaseEntity.m
//  FpdCarInCube
//
//  Created by WXC on 2017/4/11.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@implementation JYBaseEntity

- (instancetype)initWithReqType:(RequestType)type
{
    self = [super init];
    if (self)
    {
        self.reqType = type;
        self.mgr = [AFHTTPSessionManager manager];
    }
    
    return self;
}

- (NSDictionary *)package:(RequestType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:self.sign forKey:@"sign"];
    [dic safeSetObject:self.content forKey:@"content"];
    return dic;
}

@end
