//
//  NSArray+Common.m
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "NSArray+Common.h"


@implementation NSArray (Common)


#pragma mark - **Utils**
/**
 随机返回一个元素
 
 @return 随机元素，如果是空数据，返回 nil
 */
- (id)randomItem {
    if (self.count == 0) return nil;
    
    NSUInteger index = arc4random_uniform((u_int32_t)self.count);
    return self[index];
}


/**
 返回数组 Json 序列化后的字符串
 
 @return Json 序列化后的字符串
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


#pragma mark - **Sorting**
/**
 返回一个使用 compare 方法排序后的新数组
 
 排序方式是根据数组元素类型的 compare 方法
 @return 排序后的新数组
 */
- (NSArray *)sortedArray {
    return [self sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark - **StringRelated**
/**
 返回一个链接数组元素的字符串, 如果数组为空，则返回空字符串
 
 比如：
 
 NSArray *array = @[@"h", @"e", @"llo"];
 
 array = [array join];
 
 array 为 @"hello";
 
 @return 连接后的字符串
 */
- (NSString *)join {
    return [self join:@""];
}


/**
 返回一个链接数组元素的字符串, 以传入字符串参数做分隔, 如果数组为空，则返回空字符串
 
 比如：
 
 NSArray *array = @[@"hello", @"world!", @"Jeff."];
 
 array = [array join:@" "];
 
 array 为 @"hello world! Jeff.";
 
 @return 连接后的字符串
 */
- (NSString *)join:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}


#pragma mark - **GeneralMethods**
/**
 返回一个通过传入闭包处理映射后的新数组， 如果映射后为 nil，则以 NSNull 填充。
 
 比如：
 
 NSArray *array = @[@1, @2, nil];
 
 array = [array map: ^id _Nonnull(id _Nonnull object) {
 
 return object ? [object description] : nil;
 
 }];
 
 array 变为 @[@"1", @"2", NSNull]
 
 @param block 映射闭包
 @return 新数组
 */
- (NSArray *)mappedArrayUsingBlock:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    
    return array;
}


/**
 返回一个经过传入闭包处理映射后的新数组， 如果映射后为 nil，则忽略
 
 比如：
 
 NSArray *array = @[@1, @2, nil];
 
 array = [array map: ^id _Nonnull(id _Nonnull object) {
 
 return object ? [object description] : nil;
 
 }];
 
 array 变为 @[@"1", @"2"]
 
 @param block 映射闭包
 @return 新数组
 */
- (NSArray *)flatMappedArrayUsingBlock:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        id ret = block(object);
        if (!ret) continue;
        [array addObject:ret];
    }
    
    return array;
}


/**
 返回一个经过传入闭包处理筛选后的新数组
 
 比如：
 
 NSArray *array = @[@1, @2, @"3"];
 
 array = [array filter:^BOOL(id  _Nonnull object) {
 
 return [object isKindOfClass: [NSNumber class]];
 
 }];
 
 array 变为 @[@1, @2]
 
 @param block 筛选闭包
 @return 新数组
 */
- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        if (block(object))
            [array addObject:object];
    }
    return array;
}


/**
 给定一个初始值，遍历数组，通过闭包处理后返回结果
 
 比如：
 
 NSArray *array = @[@1, @2, @3];
 
 NSNumber *ret = [array reduce: @0
 
 withBlock:^id _Nonnull(id  _Nonnull accumulator, id  _Nonnull object) {
 
 return @([accumulator integerValue] + [object integerValue]);
 
 }];
 
 ret 为 @6
 
 @param initial 初始值
 @param block 处理播报
 @return 新值
 */
- (id)reduce:(id)initial usingBlock:(id (^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for (id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    return accumulator;
}


/**
 返回一个去除了重复元素的数组
 
 @return 去除重复元素的新数组
 */
- (NSArray *)unique {
    return [[NSOrderedSet orderedSetWithArray:self] array];
}


/**
 返回反序后的数组
 
 @return 反序数组
 */
- (NSArray *)reversedArray {
    return self.reverseObjectEnumerator.allObjects;
}


/**
 取数组最后 n 个数量的对象，以新数组返回
 
 如果 n >= 原数组的元素个数，则返回原数组
 
 @param n 数量
 @return 新数组
 */
- (nonnull NSArray *)subarrayFromIndex:(NSUInteger)n {
    if (self.count <= n)
        return self;
    
    NSRange range = NSMakeRange(self.count - n, n);
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
    
    return [self objectsAtIndexes:indexSet];
}


#pragma mark - **Safe Methods**
/**
 安全取数组方式，不会引数组越界抛异常
 
 注：特定情况下使用，不应过度依赖此方法而不考虑数组越界情况
 
 @param index index
 @return object or nil
 */
- (nullable id)safe_objectAtIndex:(NSUInteger)index {
    return (index < self.count) ? self[index] : nil;
}


@end
