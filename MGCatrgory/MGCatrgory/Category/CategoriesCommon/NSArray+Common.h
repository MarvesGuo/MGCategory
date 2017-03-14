//
//  NSArray+Common.h
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Common)


#pragma mark - ** Utilties **

- (nullable id)randomItem;
- (nullable NSString *)JSONString;


#pragma mark - ** Sorting **

- (nonnull NSArray *)sortedArray;           /* 排序使用的是 compare: 方法 */


#pragma mark - ** StringRelated **

- (nonnull NSString *)join;                 /* 数组内字符串拼接 */
- (nonnull NSString *)join:(nonnull NSString *)separator;


#pragma mark - ** GeneralMethods **

/*
 *  以下四个方法是 Swift 几种遍历数组的方法
 */
- (nonnull NSArray *)mappedArrayUsingBlock:(id _Nonnull (NS_NOESCAPE ^_Nonnull)(id _Nonnull object))block;
- (nonnull NSArray *)flatMappedArrayUsingBlock:(id _Nonnull (NS_NOESCAPE ^_Nonnull)(id _Nonnull object))block;
- (nonnull NSArray *)filteredArrayUsingBlock:(BOOL (NS_NOESCAPE ^ _Nonnull)(id _Nonnull object))block;
- (nonnull id)reduce:(nullable id)buinitial usingBlock:(id _Nonnull (NS_NOESCAPE ^_Nonnull)(id _Nonnull accumulator, id _Nonnull object))block;

/*
 *  以下三个方法返回对应的新的数组
 */
- (nonnull NSArray *)unique;                /* 去重 */
- (nonnull NSArray *)reversedArray;         /* 反转 */
- (nonnull NSArray *)subarrayFromIndex:(NSUInteger)n;


#pragma mark - ** Safe Methods **

- (nullable id)safe_objectAtIndex:(NSUInteger)index;

@end



