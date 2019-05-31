//
//  SelectRadView.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/29.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "SelectRadView.h"

@implementation SelectRadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)dele:(id)sender {
    self.radiuslab.text = [NSString stringWithFormat:@"%d",([self.radiuslab.text intValue]-100)>=500?([self.radiuslab.text intValue]-100):[self.radiuslab.text intValue]];
}
- (IBAction)add:(id)sender {
    self.radiuslab.text = [NSString stringWithFormat:@"%d",([self.radiuslab.text intValue]+100)<=2000?([self.radiuslab.text intValue]+100):[self.radiuslab.text intValue]];
}

@end
