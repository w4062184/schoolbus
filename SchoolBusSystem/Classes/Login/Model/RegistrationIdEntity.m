//
//  RegistrationIdEntity.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/11.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "RegistrationIdEntity.h"

@implementation RegistrationIdEntity
- (NSDictionary *)package:(RequestType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:self.userid forKey:@"userid"];
    [dic safeSetObject:self.token forKey:@"token"];
    [dic safeSetObject:self.registrationid forKey:@"registrationid"];
    
    self.sign = [Tools md5:[dic mj_JSONString]];
    self.content = [Tools base64:[dic mj_JSONString]];
    
    return [super package:type];
}
@end
