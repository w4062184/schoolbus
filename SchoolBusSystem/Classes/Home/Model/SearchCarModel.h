//
//  SearchCarModel.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/8.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCarModel : NSObject
@property (copy, nonatomic) NSString *chepaino;//车牌
@property (copy, nonatomic) NSString *currentdirect;//当前车辆方向
@property (copy, nonatomic) NSString *currentlocationx;//当前经度
@property (copy, nonatomic) NSString *currentlocationy;//当前纬度
@property (copy, nonatomic) NSString *currentspeed;//当前车辆速度
@property (copy, nonatomic) NSString *currentstatus;//车辆当前状态【0-停止，1-行驶，2-失联】
@property (copy, nonatomic) NSString *qicheid;//汽车编号
@property (copy, nonatomic) NSString *tboxid;//监控设备编号
@end
