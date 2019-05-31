//
//  JYApiConfig.h
//  FpdCarInCube
//
//  Created by WXC on 2017/4/11.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#ifndef JYApiConfig_h
#define JYApiConfig_h


#ifdef DEBUG
/***开发环境内网***/
#define baseUrl  @"http://120.79.202.130:8081/api/v1/"
#else
/***正式环境***/
#define baseUrl  @"http://api.g-telematics.com/api/v1/"


#endif

#pragma mark - 接口API
// 注册
#define UserReg        [baseUrl stringByAppendingString:@"user/reg"]
// 登录
#define UserLogin       [baseUrl stringByAppendingString:@"user/Login"]

// 验证码
#define userGcode       [baseUrl stringByAppendingString:@"user/gcode"]

// 修改密码
#define ChangePswd      [baseUrl stringByAppendingString:@"user/gcode"]

//用于用户修改账号密码
#define ChangePassword      [baseUrl stringByAppendingString:@"user/ChangePassword"]

//用于APP账号找回密码
#define GAccount      [baseUrl stringByAppendingString:@"user/GAccount"]

//更新用户APP推送的唯一标志
#define UpdateRegistrationId      [baseUrl stringByAppendingString:@"user/UpdateRegistrationId"]

// 获取信息
#define CarMess         [baseUrl stringByAppendingString:@"car/getmessagelist"]

//根据模糊车牌获取监控车辆信息列表
#define GetTextList [baseUrl stringByAppendingString:@"car/GetTextList"]

//车辆信息列表获取某台车辆详细信息

#define selectcar [baseUrl stringByAppendingString:@"car/selectcar"]

//车辆信息列表添加关注车辆
#define addcar [baseUrl stringByAppendingString:@"car/addcar"]

//用于取消关注车辆信息
#define deletecar [baseUrl stringByAppendingString:@"car/deletecar"]

//用于获取设置车辆列表
#define GetSetCarList [baseUrl stringByAppendingString:@"car/GetSetCarList"]


//用于设置上车点操作
#define addcarpoint [baseUrl stringByAppendingString:@"car/addcarpoint"]

//用于获取用户上车点
#define Gcarpoint [baseUrl stringByAppendingString:@"car/Gcarpoint"]

//用于获取监控车辆轨迹,返回车辆位置,状态,GPS时间,方向等
#define Gcargpslist [baseUrl stringByAppendingString:@"car/Gcargpslist"]

//用于获取监控车辆历史行驶轨迹,返回车辆位置,GPS时间,方向,事件标示等
#define Ghistorygpslist [baseUrl stringByAppendingString:@"car/Ghistorygpslist"]

//用于获取监控车辆历史行驶轨迹,返回车辆位置,GPS时间,方向,事件标示等
#define Ghistorylist [baseUrl stringByAppendingString:@"car/Ghistorylist"]

//用于获取取消关注车辆列表
#define GetCancelCarList [baseUrl stringByAppendingString:@"car/GetCancelCarList"]

//用于删除取消关注车辆信息
#define deleteCancelcar [baseUrl stringByAppendingString:@"car/deleteCancelcar"]

#endif /* JYApiConfig_h */
