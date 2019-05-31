//
//  NoteTableViewCell.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/23.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *detaillabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
