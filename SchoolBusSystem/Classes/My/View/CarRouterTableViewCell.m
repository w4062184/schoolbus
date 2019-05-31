//
//  CarRouterTableViewCell.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/2.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "CarRouterTableViewCell.h"

@implementation CarRouterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.addview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addview.layer.shadowOpacity = 0.1f;
    self.addview.layer.shadowRadius = 2.f;
    self.addview.layer.shadowOffset = CGSizeMake(0,0);
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(-2, -2)];
//    //添加直线
//    [path addLineToPoint:CGPointMake(Screen_width-30+2, -2)];
//    if (self.cellid == EndId) {
//        [path addLineToPoint:CGPointMake((Screen_width-30) +2, 50+2)];
//        [path addLineToPoint:CGPointMake(-2, 50+2)];
//    }
//    else{
////    [path addLineToPoint:CGPointMake((Screen_width-30) +2, 50)];
//    [path addLineToPoint:CGPointMake((Screen_width-30) +2, 48)];
//    [path addLineToPoint:CGPointMake(-2, 48)];
////    [path addLineToPoint:CGPointMake(-2, 50)];
//    }
//    [path moveToPoint:CGPointMake(-2, -2)];
//    //设置阴影路径
//    self.addview.layer.shadowPath = path.CGPath;
}
- (void)setCellid:(NSInteger)cellid{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-2, -2)];
    //添加直线
    [path addLineToPoint:CGPointMake(Screen_width-30+2, -2)];
    if (cellid == EndId) {
        [path addLineToPoint:CGPointMake((Screen_width-30) +2, 50+2)];
        [path addLineToPoint:CGPointMake(-2, 50+2)];
    }
    else{
        //    [path addLineToPoint:CGPointMake((Screen_width-30) +2, 50)];
        [path addLineToPoint:CGPointMake((Screen_width-30) +2, 48)];
        [path addLineToPoint:CGPointMake(-2, 48)];
        //    [path addLineToPoint:CGPointMake(-2, 50)];
    }
    [path moveToPoint:CGPointMake(-2, -2)];
    //设置阴影路径
    self.addview.layer.shadowPath = path.CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
