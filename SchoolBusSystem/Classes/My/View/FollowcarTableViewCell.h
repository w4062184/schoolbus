//
//  FollowcarTableViewCell.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/30.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowcarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carnumber;
@property (weak, nonatomic) IBOutlet UILabel *chexing;
@property (weak, nonatomic) IBOutlet UIButton *followbut;
@property (weak, nonatomic) IBOutlet UIButton *detailbut;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
