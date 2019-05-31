//
//  NSObject+Property.m
//  04-Runtime(动态添加属性)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>

@implementation NSObject (Property)
static char *flagTagKey = "flagTagKey";

- (void)setFlagTag:(NSInteger)flagTag
{
    NSString *flagTagStr = [NSString stringWithFormat:@"%ld",(long)flagTag];
    objc_setAssociatedObject(self, &flagTagKey,flagTagStr,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
// 给age属性提供getter和setter方法
- (NSInteger)flagTag{
    return [objc_getAssociatedObject(self, &flagTagKey) integerValue];
}

@end
