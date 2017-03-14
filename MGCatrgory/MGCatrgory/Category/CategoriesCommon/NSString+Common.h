//
//  NSString+Common.h
//  
//
//  Created by babytree on 22/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>




@interface NSString (Common) 

#pragma mark *** 基础方法 ***

- (BOOL)isValid;
- (BOOL)hasTextContent;

- (BOOL)isOnlyNumbers;
- (BOOL)isOnlyLetters;
- (BOOL)containsString:(NSString *)string;

- (NSInteger)lengthByCharacter;             /*字符数 ascii算一个 汉字算两个*/
- (NSInteger)lengthByCString;               /*转换成 C string的length*/

- (unsigned long long)unsignedLongLongValue;
- (NSData *)toData;
- (NSURL *)toURL;


#pragma mark *** 特殊字符串转换 ***
/*
 *  以下6个方法返回规定格式的字符串
 */
+ (NSString *)stringByDataSizeFormat:(NSInteger) dataSize;          /* 从bit转化为KB、MB、GB */
+ (NSString *)stringByMoneyFormat:(double) money;                   /* ￥100 */
+ (NSString *)stringByChineseMoneyFormat:(double) money;            /* 壹佰 */
+ (NSString *)stringByHexFormat:(long long int) hex;
- (NSString *)pinyinString;
- (NSString *)uppercaseFirstCharacterString;

#pragma mark *** 字符串编辑 ***

/*
 *  以下两个方法安全截取字符串 最终截取的字符串长度可能不是预期的，原因：保证enmji完全截取 emoji长度大于1 ，不定长
 */
- (NSString *)safe_substringFromIndex:(NSUInteger)fromIndex;        /* 防止含有emoji表情时造成crash 以及越界 */
- (NSString *)safe_substringToIndex:(NSUInteger)toIndex;

/*
 *  以下方法是过滤空格和换行的，默认是文字两头的位置
 */
- (NSString *)trimSpaceAndNewLine;              /* 移除两头的空格和换行符 */
- (NSString *)trimSpace;                        /* 移除两头的空格 */
- (NSString *)trimNewline;                      /* 移除两头的换行符 */

- (NSString *)trimAllSpace;
- (NSString *)trimAllNewline;

- (NSString *)trimLeftSpaceAndNewLine;          /* 移除左边的空格和换行符 */
- (NSString *)trimRightSpaceAndNewLine;         /* 移除右边的空格和换行符 */

- (NSString *)trimString:(NSString *)string;    /* 移除所有指定的字符串 */



#pragma mark *** 宽高计算 ***
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;
- (CGSize)sizeWithMaxSize:(CGSize)size font:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font;          /* 可以获取一行的宽度 */


#pragma mark *** URL相关 ***

- (NSString *)urlEncode;
- (NSString *)urlDecode;
- (NSString *)escapeHTML;


#pragma mark *** 加密相关 ***

- (NSString *)encodeForMD5;
- (NSString *)encodeForDESWithKey:(NSString *)key;
- (NSString *)decodeForDESWithKey:(NSString *)key;

- (NSString *)encodeForBase64;
- (NSString *)decodeForBase64;


#pragma mark *** 正则判断 ***
/*
 *  以下方法是判断业务对应格式的，其中UserPassword、VerifyCode 两个不是很通用的 使用的时候需要注意
 */
- (BOOL)isEmail;
- (BOOL)isValidUserPassword;        /* 是否是符合格式的密码 */
- (BOOL)isPhoneNumber;
- (BOOL)isIDCardNumberOfPRC;        /* 是否是有效的身份证号码 */
- (BOOL)isValidVerifyCode;          /* 是否是有效的验证码 */


#pragma mark *** 工具方法 ***

+ (NSString *)getUUID;              /* 生成一个UDID */
- (NSString *)getFileName;          /* 获取文件路径最后一项 */


#pragma mark *** Emoji ***

- (BOOL)isAllEmojis;
- (BOOL)isAllEmojisAndSpace;
- (BOOL)isAllEmojisNotInnerEmoji;
- (BOOL)isAllEmojisAndSpaceNotInnerEmoji;

- (BOOL)isContainsEmojis;           // 是否有表情
- (BOOL)isEmoji;                    // 是否表情，只对一个字符
- (BOOL)isInnerEmoji;

- (NSArray *)disassembleEmojis;     // 解析字符串判断Emoji分tag存储
- (NSString *)parameterEmojis;      // 编码字符串判断Emoji为API参数
- (NSString *)getEmojiUniCode;
- (NSString *)getEmojiUTF8;

@end




