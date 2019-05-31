//
//  NoteEntity.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYBaseEntity.h"

@interface NoteEntity : JYBaseEntity
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *currentpage;//当前页面
@property (copy, nonatomic) NSString *pagesize;//改页几条数据
@end
