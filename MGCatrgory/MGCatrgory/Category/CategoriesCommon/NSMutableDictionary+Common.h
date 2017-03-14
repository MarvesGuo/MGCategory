//
//  NSMutableDictionary+Common.h
//
//
//  Created by babytree on 21/02/2017.
//  Copyright © 2017 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSMutableDictionary (Common)

#pragma mark - ** Utilites **
- (void)setInt:(NSInteger)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setPoint:(CGPoint)value forKey:(NSString *)key;
- (void)setSize:(CGSize)value forKey:(NSString *)key;
- (void)setRect:(CGRect)value forKey:(NSString *)key;
- (void)setObjectWithEmptyStringPlaceholder:(id)obj forKey:(NSString *)key;


#pragma mark - ** Safe Methods **

- (void)safe_setObject:(id)object forKey:(NSString *)key;



@end
