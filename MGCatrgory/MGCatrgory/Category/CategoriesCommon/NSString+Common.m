//
//  NSString+Common.m
//
//
//  Created by babytree on 22/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Common.h"
#import "NSObject+Common.h"
#import "NSDictionary+Common.h"




@implementation NSString (Common)

#pragma mark *** 判断方法 ***

/**
 判断字符串不为 nil，NULL、NSNull 或者为空字符串
 
 */
- (BOOL)isValid
{
    return (![self isKindOfClass:[NSNull class]] && self.length);
}

/**
 判断字符串不为 trim两头空格和换行
 
 */
- (BOOL)hasTextContent
{
    return [self isValid] && [self trimSpaceAndNewLine].length;
}

/**
 判断字符串只包含数字
 
 */
- (BOOL)isOnlyNumbers
{
    NSCharacterSet *numSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numSet].location == NSNotFound);
}

/**
 判断字符串只包含字符
 
 */
- (BOOL)isOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)containsString:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

#pragma mark -
#pragma mark *** 基础方法 ***

/**
 计算字符数（汉字与英文）
 注意，这个方法只是简单的判断，假设非 ascii 字符是一个汉字
 而实际上，unicode 不是固长的。所以这个方法只可以在简单的，受限制的场景
 使用。
 
 @return 字符数
 */
- (NSInteger)lengthByCharacter {
    NSInteger i, n = [self length], l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++){
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) return 0;
    return a + b + 2 * l;
}

/**
 字符串转换成C String的长度
 
 */
- (NSInteger)lengthByCString
{
    if (! [self isValid])
        return 0;
    
    char *p = (char *)[self cStringUsingEncoding:NSUTF8StringEncoding];
    return strlen(p);
}


- (unsigned long long)unsignedLongLongValue
{
    NSInteger const GGCharacterIsNotADigit = 10;
    NSUInteger n = [self length];
    unsigned long long v,a;
    unsigned small_a, j;
    
    v=0;
    for (j=0;j<n;j++) {
        unichar c=[self characterAtIndex:j];
        small_a = (c>47)&&(c<58) ? (c-48) : GGCharacterIsNotADigit;
        if (small_a==GGCharacterIsNotADigit) continue;
        a=(unsigned long long)small_a;
        v=(10*v)+a;
    }
    return v;
}

/**
 字符串转换成NSDate对象（NSUTF8StringEncoding）
 
 */
- (NSData *)toData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 字符串转换成NSURL对象
 
 */
- (NSURL *)toURL
{
    return [NSURL URLWithString:self];
}


#pragma mark -
#pragma mark *** 特殊字符串转换 ***

/**
 字符串转换成数据存储格式  B KB、M、G
 
 */
+ (NSString *)stringByDataSizeFormat:(NSInteger) dataSize
{
    if (dataSize < 1024)
    {
        return [NSString stringWithFormat:@"%ldB", (long)dataSize];
    }
    else if (dataSize < 1024*1024)
    {
        CGFloat kbsize = (CGFloat)dataSize / 1024;
        return [NSString stringWithFormat:@"%0.2fKB", kbsize];
    }
    else if (dataSize < 1024*1024*1024)
    {
        CGFloat kbsize = (CGFloat)dataSize / (1024*1024);
        return [NSString stringWithFormat:@"%0.2fM", kbsize];
    }
    else
    {
        CGFloat kbsize = (CGFloat)dataSize / (1024*1024*1024);
        return [NSString stringWithFormat:@"%0.2fG", kbsize];
    }
}

/**
 字符串转换成价格格式  ¥100
 
 */
+ (NSString *)stringByMoneyFormat:(double) money
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    formatter.groupingSeparator = @"";
    NSString *numberString = [NSString stringWithFormat:@"¥%@", [formatter stringFromNumber:@(money)]];
    return numberString;
}

/**
 字符串转换成大写价格格式  壹佰
 
 */
+ (NSString *)stringByChineseMoneyFormat:(double) money
{
    NSMutableString *moneyStr= [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",money]];
    NSArray *MyScale = @[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *MyBase = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    NSMutableString *rstString = [NSMutableString new];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    for(NSInteger i = moneyStr.length; i > 0; --i) {
        NSInteger MyData = [[moneyStr substringWithRange:NSMakeRange(moneyStr.length - i, 1)] integerValue];
        [rstString appendString: MyBase[MyData]];
        if ([[moneyStr substringFromIndex:moneyStr.length - i + 1] integerValue] == 0 && i != 1 && i != 2) {
            [rstString appendString: @"元整"];
            break;
        }
        [rstString appendString: MyScale[i-1]];
    }
    return [rstString copy];
}

/**
 字符串转换成HEX格式
 
 */
+ (NSString *)stringByHexFormat:(long long int) hex;
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=hex%16;
        hex=hex/16;
        switch (ttmpig) {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (hex == 0) break;
    }
    return str;
}

/**
 字符串转换成拼音格式
 
 */
- (NSString *)pinyinString;
{
    NSString *string = [self copy];
    CFStringRef stringRef = (__bridge CFStringRef)string;
    CFMutableStringRef retVal = CFStringCreateMutableCopy(NULL, 0, stringRef);
    CFStringTransform(retVal, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(retVal, NULL, kCFStringTransformStripDiacritics, NO);
    return (__bridge NSString *)retVal;
}

/**
 首字母大写
 
 */
- (NSString *)uppercaseFirstCharacterString {
    NSString *resultString;
    if (self.length > 0)
    {
        NSString *firstLetter =  [self substringWithRange:NSMakeRange(0, 1)];
        firstLetter = [firstLetter uppercaseString];
        resultString =  [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    }
    return resultString;
}



#pragma mark -
#pragma mark *** 字符串编辑 ***

/**
 截取子字符串，防止越界、含有emoji表情时造成crash
 
 @param fromIndex index
 @return 子字符串
 */
- (NSString *)safe_substringFromIndex:(NSUInteger)fromIndex
{
    __block NSString *str = @"";
    __block NSInteger strLen = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         strLen += substring.length;
         // index从0开始计算
         if (strLen > fromIndex) {
             str = [str stringByAppendingString:substring];
         }
     }];
    return str;
}

/**
 截取子字符串，防止越界、含有emoji表情时造成crash
 
 @param toIndex index
 @return 子字符串
 */
- (NSString *)safe_substringToIndex:(NSUInteger)toIndex
{
    __block NSString *str = @"";
    __block NSInteger strLen = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         strLen += substring.length;
         // index从0开始计算
         if (strLen <= toIndex + 1) {
             str = [str stringByAppendingString:substring];
         }
         else{
             *stop = YES;
         }
     }];
    return str;
}

/**
 移除两头的空格和换行符
 
 */
- (NSString *)trimSpaceAndNewLine
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 移除两头的空格
 
 */
- (NSString *)trimSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 移除两头的换行
 
 */
- (NSString *)trimNewline;
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

/**
 移除所有的空格
 
 */
- (NSString *)trimAllSpace
{
    return [[self trimSpace] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 移除所有的换行
 
 */
- (NSString *)trimAllNewline
{
    NSMutableString *rstString = [NSMutableString stringWithString:[self trimNewline]];
    
    NSRange wholeRange = NSMakeRange(0, [rstString length]);
    [rstString replaceOccurrencesOfString: @"\r"
                               withString: @""
                                  options: 0
                                    range: wholeRange];
    
    NSRange wholeRange2 = NSMakeRange(0, [rstString length]);
    [rstString replaceOccurrencesOfString: @"\n"
                               withString: @""
                                  options: 0
                                    range: wholeRange2];
    
    return [rstString copy];
}

/**
 移除头空格
 
 */
- (NSString *)trimLeftSpaceAndNewLine
{
    NSString *tempString;
    tempString = [[self stringByAppendingString:@"a"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [tempString substringToIndex:[tempString length] - 1];
}

/**
 移除尾空格
 
 */
- (NSString *)trimRightSpaceAndNewLine
{
    NSString *tempString;
    tempString = [[@"a" stringByAppendingString:self] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [tempString substringFromIndex:1];
}

/**
 移除输入字符串
 
 */
- (NSString *)trimString:(NSString *)string
{
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}


#pragma mark -
#pragma mark *** 宽高计算 ***
/**
 计算在特定width字体下的展示Size
 
 @param maxWidth 最大允许宽度
 @param font 字体
 @return 计算后的尺寸
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    return [self sizeWithMaxSize:CGSizeMake(maxWidth, CGFLOAT_MAX) font:font];
}

/**
 计算在特定Size字体下的展示Size
 
 @param size 最大允许Size
 @param font 字体
 @return 计算后的尺寸
 */
- (CGSize)sizeWithMaxSize:(CGSize)size font:(UIFont *)font
{
    CGSize textSize = CGSizeZero;
    CGRect expectedFrame = [self boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
    textSize = expectedFrame.size;
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    return textSize;
}

/**
 计算字符串在特定字体下的展示宽度
 
 @param font 字体
 @return 预期Size
 */
- (CGSize)sizeWithFont:(UIFont *)font
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [self sizeWithAttributes:attributes];
}


#pragma mark -
#pragma mark *** URL相关 ***

/**
 URL encode
 
 */
- (NSString *)urlEncode
{
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:@"@#$%^&{}[]=:/,;?+\"\\~!*()'"];
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
}

/**
 URL decode
 
 */
- (NSString *)urlDecode
{
    return [self stringByRemovingPercentEncoding];
}

/**
 escape html字符串
 
 */
- (NSString *)escapeHTML
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    
    [result replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"'" withString:@"&#39;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return [result copy];
}


#pragma mark -
#pragma mark *** 加密相关 ***

- (NSString *)encodeForMD5
{
    if (![self isValid])
    {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *tempString = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [tempString appendFormat:@"%02x", (int)(digest[i])];
    }
#ifdef DEBUG
    NSLog(@"MD5 Encode Result = %@", tempString);
#endif
    return [tempString copy];
}

/**
 DES 对称加密
 
 @param key DES key
 @return 加密后的字符串
 */
- (NSString *)encodeForDESWithKey:(NSString *)key {
    NSString* rst = [NSString tripleDES:self encryptOrDecrypt:kCCEncrypt key:key];
#ifdef DEBUG
    NSLog(@"DES Encode Result=%@", rst);
#endif
    return rst;
}

/**
 DES 对称解码
 
 @param key DES key
 @return 解码后的字符串
 */
- (NSString *)decodeForDESWithKey:(NSString *)key {
    NSString* rst = [NSString tripleDES:self encryptOrDecrypt:kCCDecrypt key:key];
#ifdef DEBUG
    NSLog(@"DES Decode Result=%@", rst);
#endif
    return rst;
}

+ (NSString *)tripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key {
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt) {
        NSData *EncryptData = [[NSData alloc] initWithBase64EncodedString: plainText options:0];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    } else {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (kCCSuccess != ccStatus) {
        free(bufferPtr);
        return @"";
    }
    
    NSString *result;
    if (encryptOrDecrypt == kCCDecrypt) {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    } else {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [myData base64EncodedStringWithOptions:0];
    }
    
    free(bufferPtr);
    return result;
}

/**
 Base64加密
 
 */
- (NSString *)encodeForBase64
{
    NSData *data = [self toData];
    NSString *result = nil;
    
    result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return result;
}

/**
 Base64解密
 
 */
- (NSString *)decodeForBase64
{
    NSData *base64Data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *decodeData = [base64Data initWithBase64EncodedData:base64Data options: NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *base64String = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return base64String;
}



#pragma mark -
#pragma mark *** 正则判断 ***

/**
 是否是正确的邮箱地址
 
 */
- (BOOL)isEmail
{
    BOOL result;
    
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    result = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return result;
}

/**
 是否是符合规格的密码格式
 
 */
- (BOOL)isValidUserPassword
{
    NSString *patternStr = @"^[a-zA-Z0-9]{6,16}$";
    
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternStr];
    if ([strTest evaluateWithObject:self]) {
#ifdef DEBUG
        NSLog(@"%@ is Valid UserPasswd", self);
#endif
        return YES;
    }
    return NO;
}

/**
 是否是大陆手机号
 
 */
- (BOOL)isPhoneNumber
{
    if (!self.hasContent)
        return NO;
    if (self.length != 11)
        return NO;
    
    NSString *num = @"^((147)|(13\\d{1})|(15\\d{1})|(18\\d{1}))\\d{8}$";
    
    NSPredicate *phoneNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    return [phoneNum evaluateWithObject:self];
}

/**
 是否是有效身份证号
 
 */
- (BOOL)isIDCardNumberOfPRC
{
    
    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]] || [[value substringWithRange:NSMakeRange(17,1)] isEqualToString:@"x"]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

/**
 是否是有效的验证码
 
 */
- (BOOL)isValidVerifyCode
{
    NSString *patternStr = @"^[0-9]{4,8}$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternStr];
    return [strTest evaluateWithObject:self];
}

#pragma mark -
#pragma mark *** 工具方法 ***

/**
 生成一个 UUID
 */
+ (NSString *)getUUID
{
    return [[NSUUID UUID] UUIDString];
}

/**
 获取文件名（路径最后一项）
 */
- (NSString *)getFileName
{
    NSString *fileName;
    NSArray *pathComponents = [self pathComponents];
    if (pathComponents.count > 0)
    {
        fileName = [NSString stringWithString:[pathComponents lastObject]];
    }
    else
    {
        return @"";
    }
    return fileName;
}



#pragma mark -
#pragma mark *** Emoji ***

+ (NSDictionary *)getEmojiDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojiDic"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSDictionary *)getNationalFlagEmojiDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"nationalFlagEmojiDic"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSDictionary *)getNationalFlagEmojiCode
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"nationalFlagEmojiCode"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSDictionary *)getNationalFlagEmojiCodeFirst
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"nationalFlagEmojiCodeFirst"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}


+ (NSDictionary *)getInnerEmojiDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList"
                                                          ofType:@"plist"];
    NSDictionary *emojiDicArray = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [emojiDicArray objectForKey:@"lamadic"];
}

- (BOOL)isAllEmojisAndSpace
{
    NSArray *array = [self componentsSeparatedByCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *output = [[NSMutableString alloc] initWithCapacity:0];
    for(NSString *word in array)
    {
        [output appendString:word];
    }
    
    return [output isAllEmojis];
}

- (BOOL)isAllEmojisAndSpaceNotInnerEmoji
{
    NSArray *array = [self componentsSeparatedByCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *output = [[NSMutableString alloc] initWithCapacity:0];
    for(NSString *word in array)
    {
        [output appendString:word];
    }
    
    return [output isAllEmojisNotInnerEmoji];
}

- (BOOL)isAllEmojis
{
    __block BOOL returnValue = YES;
    
    __block NSDictionary *emojiDic = [NSString getEmojiDic];
    __block NSDictionary *nationalFlagEmojiDic = [NSString getNationalFlagEmojiDic];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if (substring.length > 0 && ![emojiDic stringForKey:[substring getEmojiUTF8]])
         {
             // 国旗双字节，需要单独判断
             if (![nationalFlagEmojiDic stringForKey:[substring getEmojiUTF8]])
             {
                 NSLog(@"%@, %@", substring, [substring getEmojiUTF8]);
                 returnValue = NO;
                 *stop = YES;
             }
         }
         
     }];
    
    return returnValue;
}

- (BOOL)isAllEmojisNotInnerEmoji
{
    __block BOOL returnValue = YES;
    __block BOOL notInner = YES;
    
    __block NSDictionary *emojiDic = [NSString getEmojiDic];
    __block NSDictionary *innerEmojiDic = [NSString getInnerEmojiDic];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if (substring.length > 0)
         {
             if (![emojiDic stringForKey:[substring getEmojiUTF8]])
             {
                 returnValue = NO;
                 *stop = YES;
             }
             else if (notInner && [innerEmojiDic stringForKey:substring])
             {
                 notInner = NO;
             }
         }
         
     }];
    
    return returnValue && notInner;
}



// 是否有表情
- (BOOL)isContainsEmojis
{
    __block BOOL returnValue = NO;
    
    __block NSDictionary *emojiDic = [NSString getEmojiDic];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if (substring.length > 0 && [emojiDic stringForKey:[substring getEmojiUTF8]])
         {
             returnValue = YES;
             *stop = YES;
         }
         
     }];
    
    return returnValue;
}

- (BOOL)isInnerEmoji
{
    if (self.length == 0)
    {
        return NO;
    }
    if (self.length > 2)
    {
        return NO;
    }
    
    NSDictionary *emojiDic = [NSString getInnerEmojiDic];
    
    if ([emojiDic stringForKey:self])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEmoji
{
    if (self.length == 0)
    {
        return NO;
    }
    if (self.length > 2)
    {
        return NO;
    }
    
    NSDictionary *emojiDic = [NSString getEmojiDic];
    
    if ([emojiDic stringForKey:[self getEmojiUTF8]])
    {
        return YES;
    }
    
    return NO;
}

- (NSArray *)disassembleEmojis
{
    __block NSMutableString *string = [[NSMutableString alloc] init];
    __block NSMutableArray *strArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    __block NSDictionary *emojiDic = [NSString getEmojiDic];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if (substring.length > 0 && [emojiDic stringForKey:[substring getEmojiUTF8]])
         {
             NSDictionary *strDic = nil;
             NSDictionary *emojiDic = nil;
             
             if (string.length > 0)
             {
                 strDic = [[NSDictionary alloc] initWithObjectsAndKeys:string, @"text", @"text", @"tag", nil];
                 [strArray addObject:strDic];
                 string = [[NSMutableString alloc] init];
             }
             
             emojiDic = [[NSDictionary alloc] initWithObjectsAndKeys:substring, @"text", @"emoji", @"tag", nil];
             [strArray addObject:emojiDic];
         }
         else
         {
             [string appendString:substring];
         }
         
     }];
    
    if (string.length > 0 )
    {
        NSDictionary *strDic = nil;
        strDic = [[NSDictionary alloc] initWithObjectsAndKeys:string, @"text", @"text", @"tag", nil];
        [strArray addObject:strDic];
    }
    
    return strArray;
}

- (NSString *)parameterEmojis
{
    __block NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    NSString *allText = nil;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         [stringArray addObject:substring];
         
     }];
    
    NSDictionary *emojiDic = [NSString getEmojiDic];
    NSDictionary *nationalFlagEmojiCodeFirst = [NSString getNationalFlagEmojiCodeFirst];
    NSDictionary *nationalFlagEmojiCode = [NSString getNationalFlagEmojiCode];
    
    NSMutableArray *stringDicArray = [[NSMutableArray alloc] init];
    
    NSMutableString *subText = [[NSMutableString alloc] init];
    
    for (NSInteger i=0; i<stringArray.count; i++)
    {
        NSString *substring = stringArray[i];
        
        NSString *utf8 = [substring getEmojiUTF8];
        
        if ([emojiDic stringForKey:utf8])
        {
            if (subText.length > 0)
            {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"text", @"tag", subText, @"text", nil];
                [stringDicArray addObject:dic];
                
                subText = [[NSMutableString alloc] init];
            }
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"emoji", @"tag", substring, @"text", nil];
            [stringDicArray addObject:dic];
        }
        else if ([nationalFlagEmojiCodeFirst stringForKey:utf8])
        {
            if (subText.length > 0)
            {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"text", @"tag", subText, @"text", nil];
                [stringDicArray addObject:dic];
                
                subText = [[NSMutableString alloc] init];
            }
            
            if (i+1 < stringArray.count)
            {
                NSString *nationalFlagString = [[NSString alloc] initWithFormat:@"%@%@", stringArray[i], stringArray[i+1]];
                
                if ([nationalFlagEmojiCode stringForKey:[nationalFlagString getEmojiUTF8]])
                {
                    i++;
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"emoji", @"tag", nationalFlagString, @"text", nil];
                    [stringDicArray addObject:dic];
                }
                else
                {
                    [subText appendString:substring];
                }
            }
            else
            {
                [subText appendString:substring];
            }
        }
        else
        {
            if ([substring isEqualToString:@"\""])
            {
                substring = @"\\\"";
            }
            if ([substring isEqualToString:@"\\"])
            {
                substring = @"\\\\";
            }
            [subText appendString:substring];
        }
    }
    
    if (subText.length > 0)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"text", @"tag", subText, @"text", nil];
        [stringDicArray addObject:dic];
    }
    
    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSDictionary *dic in stringDicArray)
    {
        if (string.length > 0)
        {
            [string appendString:@","];
        }
        
        NSString *tag = [dic stringForKey:@"tag"];
        NSString *text = [dic stringForKey:@"text"];
        
        if ([tag isEqual:@"emoji"])
        {
            NSString *str = [NSString stringWithFormat:@"{\"tag\":\"emoji\",\"text\":\"%@\"}", text];
            [string appendString:str];
        }
        else if ([tag isEqual:@"text"])
        {
            NSString *str = [NSString stringWithFormat:@"{\"tag\":\"text\",\"text\":\"%@\"}", text];
            [string appendString:str];
        }
    }
    
    allText = [NSString stringWithFormat:@"[%@]", string];
    allText = [allText stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    return allText;
}

- (NSString *)getEmojiUniCode;
{
    if (self.length == 0)
    {
        return nil;
    }
    if (self.length > 4)
    {
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
    uint32_t unicode;
    [data getBytes:&unicode length:sizeof(uint32_t)];
    NSString *unicodeStr = [NSString stringWithFormat:@"%04x", unicode];
    
    uint32_t unicode1 = 0;
    if (data.length > 4)
    {
        NSRange range = NSMakeRange(sizeof(uint32_t), sizeof(uint32_t));
        [data getBytes:&unicode1 range:range];
        unicodeStr = [NSString stringWithFormat:@"%04x-%04x", unicode, unicode1];
    }
    uint32_t unicode2 = 0;
    if (data.length > 8)
    {
        NSRange range = NSMakeRange(sizeof(uint32_t)*2, sizeof(uint32_t));
        [data getBytes:&unicode2 range:range];
        unicodeStr = [NSString stringWithFormat:@"%04x-%04x-%04x", unicode, unicode1, unicode2];
    }
    
    return unicodeStr;
}

- (NSString *)getEmojiUTF8
{
    if (self.length == 0)
    {
        return nil;
    }
    if (self.length > 4)
    {
        return nil;
    }
    
    NSString *utf8 = nil;
    
    uint8_t utf8_1 = 0;
    uint8_t utf8_2 = 0;
    uint8_t utf8_3 = 0;
    uint8_t utf8_4 = 0;
    uint8_t utf8_5 = 0;
    uint8_t utf8_6 = 0;
    uint8_t utf8_7 = 0;
    uint8_t utf8_8 = 0;
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data.length <= 1)
    {
        return nil;
    }
    
    [data getBytes:&utf8_1 length:sizeof(uint8_t)];
    if (data.length > 1)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t), sizeof(uint8_t));
        [data getBytes:&utf8_2 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x", utf8_1, utf8_2];
    }
    if (data.length > 2)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*2, sizeof(uint8_t));
        [data getBytes:&utf8_3 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x%x", utf8_1, utf8_2, utf8_3];
    }
    if (data.length > 3)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*3, sizeof(uint8_t));
        [data getBytes:&utf8_4 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4];
    }
    if (data.length > 4)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*4, sizeof(uint8_t));
        [data getBytes:&utf8_5 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5];
    }
    if (data.length > 5)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*5, sizeof(uint8_t));
        [data getBytes:&utf8_6 range:range];
        if (utf8_4 == 0xef && utf8_5 == 0xb8 && utf8_6 == 0x8f)
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x", utf8_1, utf8_2, utf8_3];
        }
        else
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5, utf8_6];
        }
    }
    if (data.length > 6)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*6, sizeof(uint8_t));
        [data getBytes:&utf8_7 range:range];
        if (utf8_5 == 0xef && utf8_6 == 0xb8 && utf8_7 == 0x8f)
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4];
        }
        else
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5, utf8_6, utf8_7];
        }
    }
    if (data.length > 7)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*7, sizeof(uint8_t));
        [data getBytes:&utf8_8 range:range];
        
        utf8 = [NSString stringWithFormat:@"%x%x%x%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5, utf8_6, utf8_7, utf8_8];
    }
    
    return utf8;
}

@end








