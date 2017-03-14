//
//  NSDictionary+Common.h
//
//  Created by babytree on 17/2/20.
//  Copyright (c) 2017年 babytree. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface NSDictionary (Common)


#pragma mark - ** Utilties **

- (BOOL)boolForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (long long)longForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key defaultString:(NSString *)defaultString;
- (CGSize)sizeForKey:(NSString *)key;
- (CGPoint)pointForKey:(NSString *)key;
- (CGRect)rectForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

- (BOOL)hasKey:(id)key;
- (NSString *)JSONString;

#pragma mark - ** General Methods **

- (void)each:(void (^)(id key, id value))block;
- (void)eachKey:(void (^)(id key))block;
- (void)eachValue:(void (^)(id value))block;
- (NSArray *)map:(id (^)(id key, id value))block;
- (NSDictionary *)dictionaryByMergingDictionary:(NSDictionary *)dictionary;

@end
