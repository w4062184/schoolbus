//
//  CarRouterDetailViewController.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/2.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
@interface CarRouterDetailViewController : UIViewController
@property (nonatomic, strong) CarModel *carmodel;
@property(nonatomic, strong) NSMutableDictionary *datasource;
@end
