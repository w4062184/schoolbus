//
//  FollowcarTableViewCell.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/30.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "FollowcarTableViewCell.h"

@implementation FollowcarTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
