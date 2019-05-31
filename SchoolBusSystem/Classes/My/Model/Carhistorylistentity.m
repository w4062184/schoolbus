//
//  Carhistorylistentity.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "Carhistorylistentity.h"

@implementation Carhistorylistentity
- (NSDictionary *)package:(RequestType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:self.userid forKey:@"userid"];
    [dic safeSetObject:self.token forKey:@"token"];
    [dic safeSetObject:self.currentpage forKey:@"currentpage"];
    [dic safeSetObject:self.pagesize forKey:@"pagesize"];
    [dic safeSetObject:self.qicheid forKey:@"qicheid"];
    
    self.sign = [Tools md5:[dic mj_JSONString]];
    self.content = [Tools base64:[dic mj_JSONString]];
    
    return [super package:type];
}
@end
