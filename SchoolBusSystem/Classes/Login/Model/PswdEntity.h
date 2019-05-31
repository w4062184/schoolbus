//
//  PswdEntity.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/20.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface PswdEntity : JYBaseEntity
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *Pswd;
@property (nonatomic, copy) NSString *Mask;
@end
