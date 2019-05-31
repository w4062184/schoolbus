//
//  Addpointrntity.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface Addpointrntity : JYBaseEntity
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *Gpslng;//GPS经度
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *Gpslat;//GPS纬度
@property (copy, nonatomic) NSString *Radius;//半径
@end
