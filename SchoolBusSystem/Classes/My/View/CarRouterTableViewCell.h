//
//  CarRouterTableViewCell.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/2.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarRouterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *addview;
@property (nonatomic, assign) NSInteger cellid;
@end
