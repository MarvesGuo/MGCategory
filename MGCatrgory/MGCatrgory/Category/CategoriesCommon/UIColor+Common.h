//
//  UIColor+Common.h
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

#pragma mark - ** Initialization **

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHex:(unsigned int)hex;
+ (UIColor *)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

#pragma mark - ** Color Components **

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;      /* 色彩空间 */

@property (nonatomic, readonly) BOOL canProvideRGBComponents;           /* 是否可以分解为 RGB */

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;
- (BOOL)hue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha;
+ (void)red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b toHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV;
+ (void)hue:(CGFloat)h saturation:(CGFloat)s brightness:(CGFloat)v toRed:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b;


@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat white;


@property (nonatomic, readonly) CGFloat hue;            /* 色相值 */
@property (nonatomic, readonly) CGFloat saturation;     /* 饱和度值 */
@property (nonatomic, readonly) CGFloat brightness;     /* 明度值 */

@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) CGFloat luminance;      /* 亮度 */

@property (nonatomic, readonly) UInt32 rgbHex;          /* RGB的16进制值 */


#pragma mark - ** Utilties **

+ (UIColor *)randomColor;
- (NSString *)stringFromColor;          /* 描述用的String*/
- (NSString *)hexStringFromColor;

- (UIImage *)toImage;


@end
