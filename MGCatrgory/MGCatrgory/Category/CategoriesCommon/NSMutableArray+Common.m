//
//  NSMutableArray+Common.m
//
//
//  Created by babytree on 21/02/2017.
//  Copyright © 2017 babytree. All rights reserved.
//

#import "NSMutableArray+Common.h"

@implementation NSMutableArray (Common)


#pragma mark - **GeneralMethods**
/**
 将元素移到数组顶
 
 @param index 被移动的元素的序号
 */
- (void)moveObjectToTopAtIndex:(NSUInteger)index {
    [self moveObjectFromIndex:index toIndex:0];
}


/**
 移动元素
 
 @param oldIndex 元素序号
 @param newIndex 新的位置序号
 */
- (void)moveObjectFromIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex {
    if (oldIndex == newIndex)
        return;
    if (oldIndex >= self.count || newIndex >= self.count)
        return;
    
    id item = [self objectAtIndex:oldIndex];
    [self removeObjectAtIndex:oldIndex];
    [self insertObject:item atIndex:newIndex];
}


/**
 删除第一个元素
 */
- (void)removeFirstObject {
    if (self.count > 1) [self removeObjectAtIndex:0];
}


/**
 获取最后一个元素返回，并从原数组中删除
 
 @return 最后一个元素，如果为空数组，则返回 nil
 */
- (id)pop {
    if (self.count == 0) return nil;
    id retVal = self.lastObject;
    [self removeLastObject];
    return retVal;
}


#pragma mark - **Safe**
/**
 安全 Add Object

 @param object 加入对象
 */
- (void)safe_addObject: (nullable id)object {
    if (!object) return;
    [self addObject:object];
}


- (void)safe_insertObject:(nullable id)object atIndex:(NSUInteger)index {
    if (!object) return;
    if (index > self.count) return;
    [self insertObject:object atIndex:index];
}


@end
