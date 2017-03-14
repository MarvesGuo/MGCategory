//
//  NSObject+Category.h
//
//
//  Created by babytree on 17-2-7.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSObject (Category)


#pragma mark - ** Utilties **

- (id)performSelector:(SEL)aSelector withObjects: (NSArray *)objs;
- (BOOL)isNotNull;
- (BOOL)hasContent;
- (BOOL)isDictionaryAndHasEntries;

#pragma mark - ** Associated Objects **

- (id)getAssociatedObjectForKey:(const char *)key;
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)removeAssociatedObjectForKey:(const char *)key;
- (void)removeAllAssociatedObjects;


#pragma mark - ** Swizzl e**

+ (BOOL)overrideClass:(Class)aClass method:(SEL)aOrigSel withMethod:(SEL)aAltSel;
+ (BOOL)overrideClass:(Class)aClass classMethod:(SEL)aOrigSel withClassMethod:(SEL)aAltSel;
+ (BOOL)exchangeClass:(Class)aClass method:(SEL)aOrigSel withMethod:(SEL)aAltSel;
+ (BOOL)exchangeClass:(Class)aClass classMethod:(SEL)aOrigSel withClassMethod:(SEL)aAltSel;


#pragma mark - ** FaultTolerant **
/*
 *  以下方法是根据OC的消息转发机制，容错处理避免找不到方法崩溃
 */
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;

@end
