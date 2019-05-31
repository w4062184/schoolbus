//
//  MapAnnotation.h
//  FpdBluetoothOBD
//
//  Created by WXC on 2018/1/16.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *icon;

@end
