//
//  NoteModel.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject
@property (copy, nonatomic) NSString *pushtime;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *messageid;
@property (copy, nonatomic) NSString *messagetype;
@end
