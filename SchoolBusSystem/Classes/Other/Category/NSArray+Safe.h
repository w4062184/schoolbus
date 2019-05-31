//
//  NSArray+Safe.h
//  ToolForZac
//
//  Created by ap2 on 15/2/2.
//  Copyright (c) 2015年 ap2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (Safe)

- (void)safeAddObject:(id)anObject;
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)safeRemoveObject:(id)object;
- (NSUInteger)safeIndexOfObject:(id)object;
@end