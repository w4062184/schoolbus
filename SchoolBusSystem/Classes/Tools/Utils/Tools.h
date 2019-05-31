//
//  Tools.h
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/9.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

// MD5
+ (NSString *)md5:(NSString *)input;

//base64
+ (NSString *)base64:(NSString *)input;

//判断是否已经超出中国范围
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//国内地图使用的坐标系统是GCJ-02而ios sdk中所用到的是国际标准的坐标系统WGS-84
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc; 
+ (CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;
+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p;
@end
