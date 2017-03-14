//
//  UIImage+Common.h
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageBasicFilterType) {
    ImageBasicFilterTypeGray = 0,
    ImageBasicFilterTypeBrown,
    ImageBasicFilterTypeInverse
};


@interface UIImage (Common)

#pragma mark - **Scaling**
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToSizeAspectFit:(CGSize)size;
- (UIImage *)scaleToSizeAspectFill:(CGSize)size;

#pragma mark - **Cropping**
- (UIImage *)croppedToRect:(CGRect)rect;
- (UIImage *)squareImage;

#pragma mark - **Stretching**
- (UIImage *)stretchableImageWithCenter;

#pragma mark - **Rotating**
- (UIImage *)rotateByDegrees:(CGFloat)degrees;
- (UIImage *)rotateByRadians:(CGFloat)radians;

#pragma mark - **Saving**
- (BOOL)saveImageToLocalPath:(NSString*)aPath;
- (BOOL)saveImageToLocalPath:(NSString*)aPath withJpegQuality:(CGFloat)quality;

#pragma mark - **Effect**
- (UIImage *)applyBasicFilterWithType:(ImageBasicFilterType)type;
- (UIImage *)applyBlackWhite;
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyBlurEffect:(CGFloat)blurAmount;

#pragma mark - **Water Mark**
- (UIImage *)imageWithWaterMark:(UIImage *)mark inRect:(CGRect)rect;
- (UIImage *)imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;
- (UIImage *)imageWithStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;
- (UIImage *)imageWithStringWaterMarkAndShadow:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font shadowcolor:(UIColor *)scolor shadowoffset:(CGPoint)offset;

#pragma mark - **Masking**
- (UIImage *)imageWithColorMask:(UIColor*)color inRect:(CGRect)rect;

#pragma mark - **Screenshot**
+ (UIImage *)screenshot;

#pragma mark - **Text Related**
// 文字转为图片
+ (UIImage *)imageFromText:(NSString *)text;
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

@end
