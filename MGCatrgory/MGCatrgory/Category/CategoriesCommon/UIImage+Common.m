//
//  UIImage+Common.m
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Common.h"
#import "NSFileManager+Common.h"
#import "UIColor+Common.h"


@implementation UIImage (Common)


#pragma mark - **Scaling**
/**
 缩放图片到指定大小
 
 @param size 新尺寸
 @return 缩放后的图片
 */
- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


/**
 按比例，AspectFit 到指定大小
 
 @param size 新尺寸
 @return 缩放后的图片
 */
- (UIImage *)scaleToSizeAspectFit:(CGSize)size {
    CGRect newRect = AVMakeRectWithAspectRatioInsideRect(self.size, CGRectMake(0, 0, size.width, size.height));
    return [self scaleToSize:newRect.size];
}


/**
 按比例，AspectFill 到指定大小
 
 @param size 新尺寸
 @return 缩放后的图片
 */
- (UIImage *)scaleToSizeAspectFill:(CGSize)size {
    CGRect newRect = AVMakeRectWithAspectRatioInsideRect(size, CGRectMake(0, 0, self.size.width, self.size.height));
    return [[self croppedToRect:newRect] scaleToSize:size];
}


#pragma mark - **Cropping**
/**
 裁剪图片
 
 @param rect 裁剪区域
 @return 裁剪后图片
 */
- (UIImage *)croppedToRect:(CGRect)rect {
    CGFloat scale = self.scale;
    CGRect cropRect = (CGRect){CGRectGetMinX(rect) * scale, CGRectGetMinY(rect) * scale, CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale};
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return cropped;
}


/**
 裁剪为正方形图片
 
 @return 居中的正方形图片
 */
- (UIImage *)squareImage {
    CGFloat x = MAX(((self.size.width - self.size.height) * 0.5), 0);
    CGFloat y = MAX(((self.size.height - self.size.width) * 0.5), 0);
    CGFloat min = MIN(self.size.width, self.size.height);
    return [self croppedToRect:CGRectMake(x, y, min, min)];
}


#pragma mark - **Stretching**
/**
 以中心点拉伸图片
 
 @return 以中心点拉伸的图片
 */
- (UIImage *)stretchableImageWithCenter {
    return [self stretchableImageWithLeftCapWidth:self.size.width/2 topCapHeight:self.size.height/2];
}


#pragma mark - **Rotating**
/**
 以角度旋转图片
 
 @param degrees 角度
 @return 旋转后的图片
 */
#define _DEGREE_2_RADIAN(_x) (_x * M_PI / 180)
- (UIImage *)rotateByDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(_DEGREE_2_RADIAN(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, _DEGREE_2_RADIAN(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 以弧度旋转图片
 
 @param radians 弧度
 @return 旋转后的图片
 */
#define _RADIAN_2_DEGREE(_x) (_x * 180/M_PI)
- (UIImage *)rotateByRadians:(CGFloat)radians {
    return [self rotateByDegrees:_RADIAN_2_DEGREE(radians)];
}


#pragma mark - **Saving**
/**
 以 jpeg 格式写入指定路径
 
 @param localPathTmp 路径
 @param qualityTmp jpeg 压缩质量
 @return YES 成功， NO 失败
 */
- (BOOL)__saveJpegImageToLocalPath:(NSString *)localPathTmp compressionQuality:(CGFloat)qualityTmp {
    NSString *directoryPath = [localPathTmp stringByDeletingLastPathComponent];
    [NSFileManager createDirectoryIfNotExist:directoryPath];
    [UIImageJPEGRepresentation(self, qualityTmp) writeToFile:localPathTmp atomically:YES];
    return [NSFileManager existFile:localPathTmp];
}


/**
 以 png 格式写入指定路径
 
 @param localPathTmp 路径
 @return YES 成功， NO 失败
 */
- (BOOL)__savePngImageToLocalPath:(NSString *)localPathTmp {
    NSString *directoryPath = [localPathTmp stringByDeletingLastPathComponent];
    [NSFileManager createDirectoryIfNotExist:directoryPath];
    [UIImagePNGRepresentation(self) writeToFile:localPathTmp atomically:YES];
    return [NSFileManager existFile:localPathTmp];
}


/**
 写入指定路径，如果是 jpeg，则以最高质量存储

 @param aPath 路径
 @return YES 成功，NO 失败
 */
- (BOOL)saveImageToLocalPath:(NSString*)aPath {
    return [self saveImageToLocalPath:aPath withJpegQuality:0];
}


/**
 写入指定路径

 @param aPath 路径
 @param quality 如果是 jpeg 图片的话，使用的压缩质量
 @return YES 成功，NO 失败
 */
- (BOOL)saveImageToLocalPath:(NSString*)aPath withJpegQuality:(CGFloat)quality {
    if ((!aPath) || ([aPath isEqualToString:@""]))
        return NO;
    
    NSString *directoryPath = [aPath stringByDeletingLastPathComponent];
    [NSFileManager createDirectoryIfNotExist:directoryPath];
    
    NSString *ext = [aPath pathExtension];
    if ([ext isEqualToString:@"png"])
        return [self __savePngImageToLocalPath: aPath];
    // the rest, we write to jpeg
    // 0. best, 1. lost. about compress.
    return [self __saveJpegImageToLocalPath:aPath compressionQuality:quality];
}


#pragma mark - **Effect**
/**
 基本滤镜
 
 @param type 基本滤镜类型
 @return filtering 后的图片
 */
- (UIImage *)applyBasicFilterWithType:(ImageBasicFilterType)type {
    //Blue: 1  Green: 2   Red: 3  ALpha 0
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            switch (type) {
                    // 灰度
                case ImageBasicFilterTypeGray: {
                    uint32_t gray = 0.3 * rgbaPixel[3] + 0.59 * rgbaPixel[2] + 0.11 * rgbaPixel[1];
                    
                    // set the pixels to gray
                    rgbaPixel[3] = gray;
                    rgbaPixel[2] = gray;
                    rgbaPixel[1] = gray;
                }
                    break;
                    // 做旧 棕色
                case ImageBasicFilterTypeBrown:
                    rgbaPixel[2] = rgbaPixel[2] * 0.7;
                    rgbaPixel[1] = rgbaPixel[1] * 0.4;
                    break;
                    // 反转颜色
                case ImageBasicFilterTypeInverse:
                    rgbaPixel[3] = 255 - rgbaPixel[3];
                    rgbaPixel[2] = 255 - rgbaPixel[2];
                    rgbaPixel[1] = 255 - rgbaPixel[1];
                    break;
                default:
                    break;
            }
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}


/**
 转黑白图片
 
 @return 黑白后的图片
 */
- (UIImage *)applyBlackWhite {
    return [self applyBasicFilterWithType:ImageBasicFilterTypeGray];
}


/**
 毛玻璃效果模拟
 
 @return 毛玻璃效果后的图片
 */
- (UIImage *)applyLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self __applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


/**
 毛玻璃效果模拟（超轻）
 
 @return 毛玻璃效果后的图片
 */
- (UIImage *)applyExtraLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self __applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


/**
 黑色毛玻璃效果模拟
 
 @return 毛玻璃效果后的图片
 */
- (UIImage *)applyDarkEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self __applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


/**
 模糊效果
 
 @param blurAmount 模糊量，0-1之间，越界则会使用0.5
 @return 模糊后的图片
 */
- (UIImage *)applyBlurEffect:(CGFloat)blurAmount {
    if (blurAmount < 0.0 || blurAmount > 1.0)
        blurAmount = 0.5;
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (!error) {
            vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


#pragma mark - **Water Mark**
/**
 图片加水印
 
 @param mark 水印图片
 @param rect 尺寸与位置
 @return 加水印后的图片
 */
- (UIImage *)imageWithWaterMark:(UIImage *)mark inRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [mark drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}


/**
 图片加文字水印
 
 @param markString 水印文字
 @param rect 尺寸与位置
 @param color 文字颜色
 @param font 文字字体
 @return 加文字水印后的图片
 */
- (UIImage *)imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font {
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [color set];
    [markString drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}


/**
 图片加文字水印
 
 @param markString 水印文字
 @param point 位置
 @param color 文字颜色
 @param font 文字字体
 @return 加文字水印后的图片
 */
- (UIImage *)imageWithStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font {
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [color set];
    [markString drawAtPoint:point withAttributes:@{NSFontAttributeName:font}];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}


/**
 图片加文字水印, 带阴影参数

 @param markString 水印文字
 @param rect 尺寸与位置
 @param color 文字颜色
 @param font 颜色字体
 @param scolor 阴影颜色
 @param offset 阴影偏移
 @return 加文字水印后的图片
 */
- (UIImage *)imageWithStringWaterMarkAndShadow:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font shadowcolor:(UIColor *)scolor shadowoffset:(CGPoint)offset {
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印文字
    [markString drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}


#pragma mark - **Masking**
/**
 图片加颜色蒙版
 
 @param color 颜色
 @param rect 蒙版尺寸与位置
 @return 加了颜色蒙版后的图片
 */
- (UIImage *)imageWithColorMask:(UIColor*)color inRect:(CGRect)rect {
    return [self imageWithWaterMark:[color toImage] inRect:rect];
}


#pragma mark - **Screenshot**
/**
 全屏截图
 
 @return 截图
 */
+ (UIImage *)screenshot {
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - **Text Related**

/**
 生成文字图片，使用30号字体， 图片尺寸 30x30

 @param text 文字
 @return 图片
 */
+ (UIImage *)imageFromText:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CGSize size  = CGSizeMake(30.0, 30.0);
    
    return [self imageFromText:text font:font size:size];
}


/**
 生成文字图片

 @param text 文字
 @param font 字体
 @param size 图片尺寸
 @return 图片
 */
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    [text drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName:font}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - **Private**
- (UIImage *)__applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (unsigned int)radius, (unsigned int)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (unsigned int)radius, (unsigned int)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (unsigned int)radius, (unsigned int)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


@end
