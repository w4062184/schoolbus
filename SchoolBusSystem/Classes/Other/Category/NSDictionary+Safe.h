//
//  DDNSDictionary+Safe.m
//  IOSDuoduo
//
//  Created by 东邪 on 14-5-29.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Safe)

- (id)safeObjectForKey:(id)key;
- (NSInteger)intValueForKey:(id)key;
- (CGFloat)doubleValueForKey:(id)key;
- (NSString*)stringValueForKey:(id)key;
- (NSNumber*)numberForKey:(id)key;
- (NSDictionary *)dictionaryForkey:(id)key;
- (NSArray *)arrayForkey:(id)key;
- (NSInteger)integerForKey:(id)key;

/**如果返回值为空则默认返回NO*/
- (BOOL)boolValueForKey:(id)key;

@end


@interface NSMutableDictionary(Safe)

- (void)safeSetObject:(id)anObject forKey:(id)aKey;
- (void)setIntValue:(int)value forKey:(id)aKey;
- (void)setDoubleValue:(double)value forKey:(id)aKey;
- (void)setStringValueForKey:(NSString*)string forKey:(id)aKey;
- (void)safeRemoveObjectForKey:(id)key;
@end

@interface NSArray (Exception)

- (id)objectForKey:(id)key;

@end
