//
//  RegisterEntity.h
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface RegisterEntity : JYBaseEntity

@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *password;
/** <#variate#> */
@property (nonatomic, copy) NSString *Mask;

@end


@interface GcodeEntity : JYBaseEntity

@property (copy, nonatomic) NSString *mobile;


@end

