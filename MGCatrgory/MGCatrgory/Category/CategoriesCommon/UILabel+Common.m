//
//  UILabel+Common.h
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "UILabel+Common.h"
#import "NSString+Common.h"

@implementation UILabel (Shortcut)

#pragma mark - ** 基本方法 **

/**
 设置字体、颜色
 
 @param font 字体
 @param color 颜色
 */
- (void)setFont:(UIFont *)font color:(UIColor *)color {
    self.textColor = color;
    self.font = font;
}

/**
 设置字体、颜色、背景色
 
 @param font 字体
 @param color 颜色
 @param backgroundColor 背景色
 */
- (void)setFont:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    [self setFont:font color:color];
}

/**
 设置字体、颜色、文本
 
 @param font 字体
 @param color 颜色
 @param text 文本
 */
- (void)setFont:(UIFont *)font color:(UIColor *)color text:(NSString *)text {
    self.text = [text isValid] ? text : @"";
    [self setFont:font color:color];
}


/**
 设置字体、颜色、文本、背景色
 
 @param font 字体
 @param color 颜色
 @param text 文本
 @param backgroundColor 背景色
 */
- (void)setFont:(UIFont *)font color:(UIColor *)color text:(NSString *)text backgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    [self setFont:font color:color text:text];
}

/**
 设置字体、颜色、文本、对齐方式
 
 @param font 字体
 @param color 颜色
 @param text 文本
 @param alignment 对齐方式
 */
- (void)setFont:(UIFont *)font color:(UIColor *)color text:(NSString *)text alignment:(NSTextAlignment)alignment {
    self.textAlignment = alignment;
    [self setFont:font color:color text:text];
}


@end

