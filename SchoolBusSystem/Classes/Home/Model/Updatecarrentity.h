//
//  Updatecarrentity.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface Updatecarrentity : JYBaseEntity
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *qicheid;//汽车编号
@property (copy, nonatomic) NSString *userid;
@end
