//
//  NSArray+Safe.m
//  ToolForZac
//
//  Created by ap2 on 15/2/2.
//  Copyright (c) 2015年 ap2. All rights reserved.
//

#import "NSArray+Safe.h"

#define isValidIndex(index)                 (index < self.count) ? YES : NO
#define isValidObject(object)               (object && ![object isKindOfClass:[NSNull class]])

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (isValidIndex(index)) {
        return [self objectAtIndex:index];
    }
    JYLog(@"警告：数组越界， 读取数组时index超出数组大小");
    return nil;
}

@end

@implementation NSMutableArray (Safe)

- (void)safeAddObject:(id)anObject
{
    if (isValidObject(anObject)) {
        
        [self addObject:anObject];
        
    }else{
        
        JYLog(@"警告：向数组Add了nil对象");
    }
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (isValidObject(anObject)) {
        
        if (index <= self.count) {
          [self insertObject:anObject atIndex:index];
        }
        
    }else{
        JYLog(@"警告：向数组Insert的Object为nil");
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (isValidIndex(index)) {
        [self removeObjectAtIndex:index];
    }else{
        JYLog(@"警告：数组越界， Remove数组数据时index超出数组大小");
    }
}

- (void)safeRemoveObject:(id)object
{
    if ([self containsObject:object]) {
        [self removeObject:object];
    }else{
        JYLog(@"警告：试图删除的object在数组中不存在");
    }
        
}

- (NSUInteger)safeIndexOfObject:(id)object
{
    if ([self containsObject:object]) {
        
        return [self indexOfObject:object];
    }
    
    JYLog(@"警告：试图从数组获取不存在的object的index");
    return 0;
}


@end
