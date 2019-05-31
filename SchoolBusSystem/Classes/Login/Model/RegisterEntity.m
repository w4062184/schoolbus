//
//  RegisterEntity.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "RegisterEntity.h"

@implementation RegisterEntity

- (NSDictionary *)package:(RequestType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:self.mobile forKey:@"mobile"];
    [dic safeSetObject:self.password forKey:@"password"];
     [dic safeSetObject:self.Mask forKey:@"Mask"];
    
    self.sign = [Tools md5:[dic mj_JSONString]];
    self.content = [Tools base64:[dic mj_JSONString]];
    
    return [super package:type];
}


@end


@implementation GcodeEntity

- (NSDictionary *)package:(RequestType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:self.mobile forKey:@"mobile"];
    
    self.sign = [Tools md5:[dic mj_JSONString]];
    self.content = [Tools base64:[dic mj_JSONString]];
    
    return [super package:type];
}


@end
