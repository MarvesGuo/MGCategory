//
//  UIDevice+Common.m
//  
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "UIDevice+Common.h"
#import "sys/sysctl.h"
#import "NSString+Common.h"


@implementation  UIDevice (Common)


#pragma mark - ** 设备基本信息 **

+ (BOOL)isiPad
{
    return [[self devicePlatform] hasPrefix:@"iPad"];
}

+ (BOOL)isiPhone
{
    return [[self devicePlatform] hasPrefix:@"iPhone"];
}

+ (BOOL)isiPod
{
    return [[self devicePlatform] hasPrefix:@"iPod"];
}

+ (BOOL)isSimulator
{
    return [[self devicePlatform] hasPrefix:@"i386"] || [[self devicePlatform] hasPrefix:@"x86_64"];
}


/**
 获取设备型号
 类似 "iPhone 5s", "iPad Mini 3"
 
 @return 设备型号
 */
+ (nonnull NSString *)deviceName
{
    NSString *r = [self devicePlatform];
    
    if ([r isEqualToString:@"iPhone1,1"]) return @"iPhone";
    else if ([r isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    else if ([r isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    else if ([r isEqualToString:@"iPhone3,1"] || [r isEqualToString:@"iPhone3,2"] || [r isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    else if ([r isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    else if ([r isEqualToString:@"iPhone5,1"] || [r isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    else if ([r isEqualToString:@"iPhone5,3"] || [r isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    else if ([r isEqualToString:@"iPhone6,1"] || [r isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    else if ([r isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    else if ([r isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    else if ([r isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    else if ([r isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    else if ([r isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    else if ([r isEqualToString:@"iPhone9,1"] || [r isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    else if ([r isEqualToString:@"iPhone9,2"] || [r isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    else if ([r isEqualToString:@"iPod1,1"]) return @"iPod Touch";
    else if ([r isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    else if ([r isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    else if ([r isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    else if ([r isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    else if ([r isEqualToString:@"iPod7,1"]) return @"iPod Touch 6G";
    else if ([r isEqualToString:@"iPad1,1"]) return @"iPad";
    else if ([r isEqualToString:@"iPad2,1"] || [r isEqualToString:@"iPad2,2"] || [r isEqualToString:@"iPad2,3"] || [r isEqualToString:@"iPad2,4"]) return @"iPad 2";
    else if ([r isEqualToString:@"iPad2,5"] || [r isEqualToString:@"iPad2,6"] || [r isEqualToString:@"iPad2,7"]) return @"iPad Mini";
    else if ([r isEqualToString:@"iPad4,4"] || [r isEqualToString:@"iPad4,5"] || [r isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    else if ([r isEqualToString:@"iPad4,7"] || [r isEqualToString:@"iPad4,8"] || [r isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    else if ([r isEqualToString:@"iPad5,1"] || [r isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    else if ([r isEqualToString:@"iPad3,1"] || [r isEqualToString:@"iPad3,2"] || [r isEqualToString:@"iPad4,9"]) return @"iPad 3";
    else if ([r isEqualToString:@"iPad3,4"] || [r isEqualToString:@"iPad3,5"] || [r isEqualToString:@"iPad3,6"]) return @"iPad 4";
    else if ([r isEqualToString:@"iPad4,1"] || [r isEqualToString:@"iPad4,2"] || [r isEqualToString:@"iPad4,3"]) return @"iPad Air";
    else if ([r isEqualToString:@"iPad5,3"] || [r isEqualToString:@"iPad5,4"]) return @"iPad Air2";
    else if ([r isEqualToString:@"iPad6,8"] || [r isEqualToString:@"iPad6,7"]) return @"iPad Pro (12.9\")";
    else if ([r isEqualToString:@"iPad6,3"] || [r isEqualToString:@"iPad6,4"]) return @"iPad Pro (9.7\")";
    else if ([r isEqualToString:@"i386"] || [r isEqualToString:@"x86_64"]) return @"Simulator";
    
    //Probably new device
    if ([r containsString:@"iPod"]) return @"iPod Touch";
    else if ([r containsString:@"iPad"]) return @"iPad";
    else if ([r containsString:@"iPhone"]) return @"iPhone";
    
    return @"Unknown";
}

+ (nonnull NSString *)devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/**
 手机存储空间大小
 
 */
+ (nonnull NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

/**
 手机可用存储空间大小
 
 */
+ (nonnull NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}


#pragma mark - ** iOS版本号相关 **

+ (CGFloat)systemVision
{
    return [[self currentDevice].systemVersion floatValue];
}

/**
 iOS系统号是否大于等于 传入的系统号

 */
+ (BOOL)systemVisionGreaterThanOrEqualTo:(CGFloat) anotherSystemVision
{
    return [self systemVision] >= anotherSystemVision;
}


#pragma mark - ** 屏幕大小相关 **

+ (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)isIphone4Screen {
    return (CGSizeEqualToSize(CGSizeMake(320.0f, 480.0f), [self screenSize]));
}

+ (BOOL)isIphone5Screen {
    return (CGSizeEqualToSize(CGSizeMake(320.0f, 568.0f), [self screenSize]));
}

+ (BOOL)isIphone6Screen {
    return (CGSizeEqualToSize(CGSizeMake(375.0f, 667.0f), [self screenSize]));
}

+ (BOOL)isIphone6PScreen {
    return (CGSizeEqualToSize(CGSizeMake(414.0f, 736.0f), [self screenSize]));
}



@end

