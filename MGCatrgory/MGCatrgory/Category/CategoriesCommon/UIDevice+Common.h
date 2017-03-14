//
//  UIDevice+Common.h
//  
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIDevice (Common)


#pragma mark - ** 设备基本信息 **

+ (BOOL)isiPad;
+ (BOOL)isiPhone;
+ (BOOL)isiPod;
+ (BOOL)isSimulator;

+ (nonnull NSString *)deviceName;               /* iPhone SE、iPad Pro ...*/

/*
 *  下面两个方法返回系统存储空间的相关信息
 */
+ (nonnull NSNumber *)totalDiskSpace;
+ (nonnull NSNumber *)freeDiskSpace;


#pragma mark - ** iOS版本号相关 **

+ (CGFloat)systemVision;

+ (BOOL)systemVisionGreaterThanOrEqualTo:(CGFloat) anotherSystemVision;


#pragma mark - ** 屏幕大小相关 **

+ (CGSize)screenSize;

+ (BOOL)isIphone4Screen;
+ (BOOL)isIphone5Screen;
+ (BOOL)isIphone6Screen;
+ (BOOL)isIphone6PScreen;


@end
