//
//  DDNSDictionary+Safe.m
//  IOSDuoduo
//
//  Created by 东邪 on 14-5-29.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "NSDictionary+Safe.h"
//#import "NSString+Additions.h"

//#define isValidKey(x) (!x || [x isKindOfClass:[NSNull class]])

#define isValidKey(key) ((key) != nil && ![key isKindOfClass:[NSNull class]])
#define isValidValue(value) (((value) != nil) && ![value isKindOfClass:[NSNull class]])

@implementation NSDictionary (Safe)


- (id)safeObjectForKey:(id)key{
    if (!isValidKey(key)) {
        
        JYLog(@"警告：key为nil");
        return nil;
    }
    id obj = [self objectForKey:key];
    if(!isValidValue(obj)){
         JYLog(@"警告：object为nil");
        return nil;
    }
    
    return obj;
}
- (NSInteger)intValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    return [obj integerValue];
}
- (CGFloat)doubleValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    return [obj floatValue];
}
- (NSString*)stringValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    
    return nil;
}

- (NSNumber*)numberForKey:(id)key
{
    id value = [self safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSInteger)integerForKey:(id)key
{
    id value = [self safeObjectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)boolValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    if (obj && ![obj isKindOfClass:[NSNull class]]) {
        return [obj boolValue];
    }
    return NO;
}

- (NSDictionary *)dictionaryForkey:(id)key{
    id obj = [self safeObjectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}

- (NSArray *)arrayForkey:(id)key{
    id obj = [self safeObjectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return nil;
}


@end



@implementation NSMutableDictionary(Safe)

- (void)safeSetObject:(id)anObject forKey:(id)aKey{
    if (!isValidKey(aKey)) {
        return;
    }
    if ([aKey isKindOfClass:[NSString class]]) {
        [self setValue:anObject forKey:aKey];
    }
    else{
        if (anObject != nil) {
            [self setObject:anObject forKey:aKey];
        }
        else{
            [self removeObjectForKey:aKey];
        }
    }
}
- (void)setIntValue:(int)value forKey:(id)aKey{
    [self safeSetObject:[[NSNumber numberWithInt:value] stringValue] forKey:aKey];
}
- (void)setDoubleValue:(double)value forKey:(id)aKey{
    [self safeSetObject:[[NSNumber numberWithDouble:value] stringValue] forKey:aKey];

}
- (void)setStringValueForKey:(NSString*)string forKey:(id)aKey{
    [self safeSetObject:string forKey:aKey];
}

- (void)safeRemoveObjectForKey:(id)key{
    
    if (isValidKey(key))
    {
        id object = [self safeObjectForKey:key];
        if (isValidValue(object))
        {
            [self removeObjectForKey:key];
        }
        else
        {
            JYLog(@"ERROR ：删除字典内的值发生错误");
        }
    }
}


@end


@implementation NSArray(Exception)

- (id)objectForKey:(id)key{
#ifdef DEBUG
    NSAssert(NO, @"NSArray should not call objectForKey, you should check your code!");
    return nil;
#else
    return nil;
#endif
}

@end
