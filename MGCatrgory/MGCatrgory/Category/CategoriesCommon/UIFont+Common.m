//
//  UIFont+Common.m
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "UIFont+Common.h"


@implementation UIFont (Common)

#pragma mark - **Privates**
+ (NSString *)__systemFontName {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending))
        return @".SFUIDisplay";
    else if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending))
        return @"HelveticaNeue";
    return [UIFont systemFontOfSize:10].fontName;
}

+ (UIFont *)__getFontWithWeight:(NSString *)weight fontSize:(CGFloat)fontSize {
    NSArray *fontFamily = [[self __systemFontName] componentsSeparatedByString:@"-"];
    if (fontFamily.count > 0) {
        NSString *fontFamilyStr = [fontFamily firstObject];
        NSString *fontName = [NSString stringWithFormat:@"%@-%@",fontFamilyStr, weight];
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        if (font) return font;
#ifdef DEBUG
        NSLog(@"can not found font %@", fontName);
#endif
    }
    return [UIFont systemFontOfSize:fontSize];
}


#pragma mark - **Utils**

/**
 返回 ultra light 字重的字体

 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)ultraLightSystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"UltraLight" fontSize:fontSize];
}


/**
 返回 thin 字重的字体
 
 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)thinSystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"Thin" fontSize:fontSize];
}


/**
 返回 light 字重的字体
 
 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"Light" fontSize:fontSize];
}


/**
 返回 medium 字重的字体
 
 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)mediumSystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"Medium" fontSize:fontSize];
}


/**
 返回 semibold 字重的字体
 
 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)semiboldSystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"Semibold" fontSize:fontSize];
}


/**
 返回 heavy 字重的字体
 
 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)heavySystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"Heavy" fontSize:fontSize];
}


/**
 返回 black 字重的字体
 
 @param fontSize 字号
 @return UIFont
 */
+ (UIFont *)blackSystemFontOfSize:(CGFloat)fontSize {
    return [self __getFontWithWeight:@"Black" fontSize:fontSize];
}


/**
 返回 iPhone 6 的屏宽比计算出的字号的系统字体

 @param fontSize 字号，会用 iPhone 6 的屏宽比去再次计算
 @return UIFont
 */
+ (UIFont *)systemFontOfScaledSize:(CGFloat)fontSize {
    CGFloat scaledSize = ((fontSize)*([UIScreen mainScreen].bounds.size.width)/375.f);
    return [UIFont systemFontOfSize:scaledSize];
}


/**
 返回 iPhone 6 的屏宽比计算出的字号的系统粗号字体
 
 @param fontSize 字号，会用 iPhone 6 的屏宽比去再次计算
 @return UIFont
 */
+ (UIFont *)boldSystemFontOfScaledSize:(CGFloat)fontSize {
    CGFloat scaledSize = ((fontSize)*([UIScreen mainScreen].bounds.size.width)/375.f);
    return [UIFont boldSystemFontOfSize:scaledSize];
}

/**
 注册第三方字体

 @param data 字体文件 Data
 @return 注册是否成功，YES or NO
 */
+ (BOOL)registerFontWithData:(NSData *)data {
    if (!data)
        return nil;
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        CFRelease(errorDescription);
        CFRelease(font);
        CFRelease(providerRef);
        return NO;
    }
    CFRelease(font);
    CFRelease(providerRef);
    return YES;
}


#pragma mark - **Develop Helper**

/**
 打印当前设备所有可使用字体

 @return 字体数组
 */
+ (NSArray <NSString *> *)allFonts {
    NSArray *fontFamilies = [UIFont familyNames];
    NSMutableArray<NSString *> *ret = [NSMutableArray array];
    for (NSString *fontFamily in fontFamilies) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        [ret addObject:[NSString stringWithFormat:@"%@: %@", fontFamily, fontNames]];
    }
    return [ret copy];
}

@end
