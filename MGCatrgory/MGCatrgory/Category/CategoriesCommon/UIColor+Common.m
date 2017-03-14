//
//  UIColor+Common.m
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)


#pragma mark - **Initialization**
/**
 通过16进制字符串获取 UIColor，支持 0x 0X # 前缀

 @param stringToConvert 颜色描述16进制字符串
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


/**
 通过16进制值获取 UIColor

 @param hex 16进制颜色值
 @return UIColor
 */
+ (UIColor *)colorWithHex:(unsigned int)hex {
    return [UIColor colorWithHex:hex alpha:1];
}

/**
 通过16进制值获取 UIColor，包含 Alpha 通道值
 
 @param hex 16进制颜色值
 @param alpha alpha 值
 @return UIColor
 */
+ (UIColor *)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}


#pragma mark - **Color Components**
/**
 获取颜色的 space model

 @return CGColorSpaceModel
 */
- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}


/**
 返回是否可以分解为 RGB

 @return YES or NO
 */
- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}


/**
 获取 RGBA 颜色值，如果不可获取，返回 NO

 @param red R
 @param green G
 @param blue B
 @param alpha A
 @return YES or NO
 */
- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r,g,b,a;
    
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
        default: // We don't know how to handle this model
            return NO;
    }
    if (red) *red = r;
    if (green) *green = g;
    if (blue) *blue = b;
    if (alpha) *alpha = a;
    
    return YES;
}


/**
 获取 hue，saturation， brightness 和 alpha
 
 该方法是通过 RGB 转换的

 @param hue hue
 @param saturation saturation
 @param brightness brightness
 @param alpha alpha
 @return YES or NO
 */
- (BOOL)hue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return NO;
    
    [UIColor red:r green:g blue:b toHue:hue saturation:saturation brightness:brightness];
    
    if (alpha) *alpha = a;
    
    return YES;
}


/**
 转换 RGB 到 HSV
 */
+ (void)red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b toHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV {
    CGFloat h,s,v;
    
    // From Foley and Van Dam
    
    CGFloat max = MAX(r, MAX(g, b));
    CGFloat min = MIN(r, MIN(g, b));
    
    // Brightness
    v = max;
    
    // Saturation
    s = (max != 0.0f) ? ((max - min) / max) : 0.0f;
    
    if (s == 0.0f){
        // No saturation, so undefined hue
        h = 0.0f;
    } else {
        // Determine hue
        CGFloat rc = (max - r) / (max - min); // Distance of color from red
        CGFloat gc = (max - g) / (max - min); // Distance of color from green
        CGFloat bc = (max - b) / (max - min); // Distance of color from blue
        
        if (r == max) h = bc - gc; // resulting color between yellow and magenta
        else if (g == max) h = 2 + rc - bc; // resulting color between cyan and yellow
        else /* if (b == max) */ h = 4 + gc - rc; // resulting color between magenta and cyan
        
        h *= 60.0f; // Convert to degrees
        if (h < 0.0f) h += 360.0f; // Make non-negative
    }
    
    if (pH) *pH = h;
    if (pS) *pS = s;
    if (pV) *pV = v;
}


/**
 转换 HSV 到 RGB
 */
+ (void)hue:(CGFloat)h saturation:(CGFloat)s brightness:(CGFloat)v toRed:(CGFloat *)pR green:(CGFloat *)pG blue:(CGFloat *)pB {
    CGFloat r = 0, g = 0, b = 0;
    
    // From Foley and Van Dam
    if (s == 0.0f) {
        // Achromatic color: there is no hue
        r = g = b = v;
    } else {
        // Chromatic color: there is a hue
        if (h == 360.0f) h = 0.0f;
        h /= 60.0f; // h is now in [0, 6)
        
        int i = floorf(h); // largest integer <= h
        CGFloat f = h - i; // fractional part of h
        CGFloat p = v * (1 - s);
        CGFloat q = v * (1 - (s * f));
        CGFloat t = v * (1 - (s * (1 - f)));
        
        switch (i) {
            case 0: r = v; g = t; b = p; break;
            case 1: r = q; g = v; b = p; break;
            case 2: r = p; g = v; b = t; break;
            case 3: r = p; g = q; b = v; break;
            case 4: r = t; g = p; b = v; break;
            case 5: r = v; g = p; b = q; break;
        }
    }
    
    if (pR) *pR = r;
    if (pG) *pG = g;
    if (pB) *pB = b;
}

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome)
        return c[0];
    return c[1];
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome)
        return c[0];
    return c[2];
}

- (CGFloat)white {
    NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)hue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -hue");
    
    CGFloat h = 0.0f;
    [self hue:&h saturation:nil brightness:nil alpha:nil];
    return h;
}

- (CGFloat)saturation {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -saturation");
    
    CGFloat s = 0.0f;
    [self hue:nil saturation:&s brightness:nil alpha:nil];
    return s;
}

- (CGFloat)brightness {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -brightness");
    
    CGFloat v = 0.0f;
    [self hue:nil saturation:nil brightness:&v alpha:nil];
    return v;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)luminance {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use luminance");
    
    CGFloat r,g,b;
    if (![self red:&r green:&g blue:&b alpha:nil]) return 0.0f;
    
    // http://en.wikipedia.org/wiki/Luma_(video)
    // Y = 0.2126 R + 0.7152 G + 0.0722 B
    
    return r*0.2126f + g*0.7152f + b*0.0722f;
}

- (UInt32)rgbHex {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
    r = MIN(MAX(r, 0.0f), 1.0f);
    g = MIN(MAX(g, 0.0f), 1.0f);
    b = MIN(MAX(b, 0.0f), 1.0f);
    
    return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}


#pragma mark - **Utils**
/**
 随机取一个颜色
 
 @return UIColor
 */
+ (UIColor *)randomColor {
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


/**
 字符串描述色值，rgb 形式

 @return 描述
 */
- (NSString *)stringFromColor {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -stringFromColor");
    
    NSString *result;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            result = [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
            break;
        case kCGColorSpaceModelMonochrome:
            result = [NSString stringWithFormat:@"{%0.3f, %0.3f}", self.white, self.alpha];
            break;
        default:
            result = nil;
    }
    
    return result;
}


/**
 字符串描述色值，16进制形式

 @return 描述
 */
- (NSString *)hexStringFromColor {
    return [NSString stringWithFormat:@"%0.6X", (unsigned int)self.rgbHex];
}


/**
 生成一个 1x1 的纯色图片

 @return UIImage
 */
- (UIImage *)toImage {
    CGFloat alpha;
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    BOOL opaqueImage = (fabs(alpha - 1.0) <= FLT_EPSILON);
    CGSize size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(size, opaqueImage, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
