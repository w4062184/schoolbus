//
//  ActionthreeTableViewCell.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/2.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionthreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actionlab;
@property (weak, nonatomic) IBOutlet UILabel *numberlab;
@property (weak, nonatomic) IBOutlet UIView *addview;
@property (nonatomic, assign) NSInteger cellid;
@end
