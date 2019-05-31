//
//  Carhistorydetailentity.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/8.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface Carhistorydetailentity : JYBaseEntity
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *startime;//开始
@property (copy, nonatomic) NSString *endtime;//结束
@property (copy, nonatomic) NSString *qicheid;
@end
