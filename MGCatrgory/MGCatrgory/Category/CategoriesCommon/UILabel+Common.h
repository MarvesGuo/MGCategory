//
//  UILabel+Common.h
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKitDefines.h>



@interface UILabel (Common)

#pragma mark - ** 基本方法 **

- (void)setFont:(nullable UIFont *)font color:(nullable UIColor *)color;
- (void)setFont:(nullable UIFont *)font color:(nullable UIColor *)color backgroundColor:(nullable UIColor *)backgroundColor;
- (void)setFont:(nullable UIFont *)font color:(nullable UIColor *)color text:(nullable NSString *)text;
- (void)setFont:(nullable UIFont *)font color:(nullable UIColor *)color text:(nullable NSString *)text backgroundColor:(nullable UIColor *)backgroundColor;
- (void)setFont:(nullable UIFont *)font color:(nullable UIColor *)color text:(nullable NSString *)text alignment:(NSTextAlignment)alignment;



@end




