//
//  NSDictionary+Common.m
//
//  Created by babytree on 17/2/20.
//  Copyright (c) 2017年 babytree. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)


#pragma mark - **Utils**
/**
 取 BOOL 类型数据
 
 @param key key
 @return BOOL 类型数据，如果不存在，则为 NO
 */
- (BOOL)boolForKey:(NSString *)key{
    BOOL value = NO;
    
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && ([object isKindOfClass:[NSValue class]] || [object isKindOfClass:[NSString class]]))
        value = [object boolValue];
    
    return value;
}


/**
 取 float 类型数据
 
 @param key key
 @return float 类型数据，如果不存在，则为 0.0f
 */
- (float)floatForKey:(NSString *)key{
    float value = 0.0f;
    
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && ([object isKindOfClass:[NSValue class]] || [object isKindOfClass:[NSString class]]))
        value = [object floatValue];
    
    return value;
}


/**
 取 NSInteger 类型数据
 
 @param key key
 @return NSInteger 类型数据，如果不存在，则为 0
 */
- (NSInteger)integerForKey:(NSString *)key{
    NSInteger value = 0;
    
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && ([object isKindOfClass:[NSValue class]] || [object isKindOfClass:[NSString class]]))
        value = [object integerValue];
    
    return value;
}


/**
 取 double 类型数据
 
 @param key key
 @return double 类型数据，如果不存在，则为 0.0f
 */
- (double)doubleForKey:(NSString *)key{
    double value = 0.0f;
    
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && ([object isKindOfClass:[NSValue class]] || [object isKindOfClass:[NSString class]]))
        value = [object doubleValue];
    
    return value;
}


/**
 取long long类型数据

 @param key key
 @return long long 类型数据，如果不存在，则为 0
 */
- (long long)longForKey:(NSString *)key {
    long long value = 0;
    
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && ([object isKindOfClass:[NSValue class]] || [object isKindOfClass:[NSString class]]))
        value = [object longLongValue];
    
    return value;
}


/**
 取 NSString 类型数据
 
 @param key key
 @return NSString 类型数据，如果不存在，则为 nil
 */
- (NSString *)stringForKey:(NSString *)key{
    NSString *value;
    
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]])
            value = object;
        else if ([object isKindOfClass:[NSNumber class]])
            value = [object stringValue];
    }
    return value;
}


/**
 取 NSString 类型数据, 如果不存在，用 defaultString 代替
 
 @param key key
 @return NSString 类型数据，如果不存在，则为 defaultString
 */
- (NSString *)stringForKey:(NSString *)key defaultString:(NSString *)defaultString{
    NSString *value = [self stringForKey:key];
    
    return value?:defaultString;
}


/**
 取 CGSize 类型数据
 
 @param key key
 @return CGSize 类型数据，如果不存在，则为 CGSizeZero
 */
- (CGSize)sizeForKey:(NSString *)key {
    CGSize size = CGSizeZero;
    NSDictionary *dictionary = [self valueForKey:key];
    
    if (![dictionary isKindOfClass:[NSNull class]] && [dictionary isKindOfClass:[NSDictionary class]]) {
        BOOL success = CGSizeMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)dictionary, &size);
        if (success) return size;
    }
    
    return CGSizeZero;
}


/**
 取 CGPoint 类型数据
 
 @param key key
 @return CGPoint 类型数据，如果不存在，则为 CGPointZero
 */
- (CGPoint)pointForKey:(NSString *)key
{
    CGPoint point = CGPointZero;
    NSDictionary *dictionary = [self valueForKey:key];
    
    if (![dictionary isKindOfClass:[NSNull class]] && [dictionary isKindOfClass:[NSDictionary class]]) {
        BOOL success = CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)dictionary, &point);
        if (success) return point;
    }
    
    return CGPointZero;
}


/**
 取 CGRect 类型数据
 
 @param key key
 @return CGRect 类型数据，如果不存在，则为 CGRectZero
 */
- (CGRect)rectForKey:(NSString *)key {
    CGRect rect = CGRectZero;
    NSDictionary *dictionary = [self valueForKey:key];
    
    if (![dictionary isKindOfClass:[NSNull class]] && [dictionary isKindOfClass:[NSDictionary class]]) {
        BOOL success = CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)dictionary, &rect);
        if (success) return rect;
    }
    
    return CGRectZero;
}


/**
 取 NSArray 类型数据
 
 @param key key
 @return NSArray 类型数据，如果不存在，则为 nil
 */
- (NSArray *)arrayForKey:(NSString *)key {
    NSArray *value = nil;
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && [object isKindOfClass:[NSArray class]])
        value = object;
    
    return value;
}


/**
 取 NSDictionary 类型数据
 
 @param key key
 @return NSDictionary 类型数据，如果不存在，则为 nil
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key {
    NSDictionary *value = nil;
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNull class]] && [object isKindOfClass:[NSDictionary class]])
        value = object;
    
    return value;
}


/**
 检查是否包含该字段
 
 @param key key
 @return YES or NO
 */
- (BOOL)hasKey:(id)key {
    return !!self[key];
}


/**
 返回 JSON 序列化后的字符串
 
 @return JSON 序列化后的字符串
 */
- (NSString *)JSONString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


#pragma mark - **General Methods**
/**
 遍历字典，以键值对形式传入参数

 @param block block
 */
- (void)each:(void (^)(id k, id v))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}


/**
 遍历字典key

 @param block block
 */
- (void)eachKey:(void (^)(id k))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key);
    }];
}


/**
 遍历字典value

 @param block block
 */
- (void)eachValue:(void (^)(id v))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
}


/**
 遍历字典，返回映射处理后的数组

 @param block 映射处理闭包
 @return 映射后的数组
 
 */
- (NSArray *)map:(id (^)(id key, id value))block {
    NSMutableArray *array = [NSMutableArray array];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = block(key, obj);
        if (object) {
            [array addObject:object];
        }
    }];
    
    return array;
}


/**
 整合两个字典，如果传入的字典和调用方字典有相同的key，返回的字典将使用传入字典的该字段的值

 @param dictionary 传入字典
 @return 整合后的字典
 */
- (NSDictionary *)dictionaryByMergingDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *merged = [NSMutableDictionary dictionaryWithDictionary:self];
    [merged addEntriesFromDictionary:dictionary];
    return merged;
}


@end
