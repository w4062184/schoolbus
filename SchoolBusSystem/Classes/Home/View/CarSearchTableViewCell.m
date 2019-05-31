//
//  CarSearchTableViewCell.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/30.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "CarSearchTableViewCell.h"

@implementation CarSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
//    [_add.layer setMasksToBounds:YES];
//    [_add.layer setCornerRadius:3.0]; //设置矩圆角半径
//    [_add.layer setBorderWidth:1.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255, 175, 4, 1 });
//    [_add.layer setBorderColor:[UIColor colorWithRed:255.0/255 green:175.0/255 blue:4.0/255 alpha:1].CGColor];//边框颜色

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
