//
//  NSMutableDictionary+Common.m
//
//
//  Created by babytree on 21/02/2017.
//  Copyright © 2017 babytree. All rights reserved.
//

#import "NSMutableDictionary+Common.h"

@implementation NSMutableDictionary (Common)


#pragma mark - **Utils**
/**
 以 NSNumber 形式写入 NSInteger
 
 @param value NSInteger
 @param key key
 */
- (void)setInt:(NSInteger)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}


/**
 以 NSNumber 形式写入 BOOL
 
 @param value BOOL
 @param key key
 */
- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}


/**
 以 NSNumber 形式写入 float
 
 @param value float
 @param key key
 */
- (void)setFloat:(float)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}


/**
 以 NSNumber 形式写入 double
 
 @param value double
 @param key key
 */
- (void)setDouble:(double)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}


/**
 以 DictionaryRepresentation 形式写入 CGPoint
 
 @param value CGPoint
 @param key key
 */
- (void)setPoint:(CGPoint)value forKey:(NSString *)key {
    CFDictionaryRef dictionary = CGPointCreateDictionaryRepresentation(value);
    NSDictionary *pointDict = [NSDictionary dictionaryWithDictionary: (__bridge NSDictionary *)dictionary];
    CFRelease(dictionary);
    
    [self setValue:pointDict forKey:key];
}


/**
 以 DictionaryRepresentation 形式写入 CGSize
 
 @param value CGSize
 @param key key
 */
- (void)setSize:(CGSize)value forKey:(NSString *)key {
    CFDictionaryRef dictionary = CGSizeCreateDictionaryRepresentation(value);
    NSDictionary *sizeDict = [NSDictionary dictionaryWithDictionary: (__bridge NSDictionary *)dictionary];
    CFRelease(dictionary);
    
    [self setValue:sizeDict forKey:key];
}

/**
 以 DictionaryRepresentation 形式写入 CGRect
 
 @param value CGRect
 @param key key
 */
- (void)setRect:(CGRect)value forKey:(NSString *)key {
    CFDictionaryRef dictionary = CGRectCreateDictionaryRepresentation(value);
    NSDictionary *rectDict = [NSDictionary dictionaryWithDictionary: (__bridge NSDictionary *)dictionary];
    CFRelease(dictionary);
    
    [self setValue:rectDict forKey:key];
}

/**
 尝试写入对象，如果为 nil，则写入空字符串，会检查key，如果key为nil，则不写入
 
 @param obj 值
 @param key key
 */
- (void)setObjectWithEmptyStringPlaceholder:(id)obj forKey:(NSString *)key {
    if (!key) return;
    [self setObject:(obj)?obj:@"" forKey:key];
}

/**
 安全写入数据，会检查 value 和 key 是否为空，key 会检查是否为空字符串，如果是，则不写入
 
 @param object 值
 @param key key
 */
- (void)safe_setObject:(id)object forKey:(NSString *)key
{
    if (!object || !key || key.length == 0)
        return;
    [self setObject:object forKey:key];
}

@end
