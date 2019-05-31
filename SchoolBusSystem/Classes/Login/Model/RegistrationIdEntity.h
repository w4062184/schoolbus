//
//  RegistrationIdEntity.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/11.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface RegistrationIdEntity : JYBaseEntity
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *registrationid;
@end
