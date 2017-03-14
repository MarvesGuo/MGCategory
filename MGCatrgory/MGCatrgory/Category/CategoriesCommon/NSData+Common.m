//
//  NSData+Common.m
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "NSData+Common.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Common)


#pragma mark - **Coding**
/**
 decode 字符串后，返回 data

 @param string base64 编码的字符串
 @return decode 后的 NSData
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string {
    return [[NSData alloc] initWithBase64EncodedString:string options:0];
}


/**
 返回 base64 编码后的字符串

 @return base64 编码后的字符
 */
- (NSString *)base64EncodedString {
    return [self base64EncodedStringWithOptions:0];
}


/**
 返回 MD5 字符串

 @return MD5 字符串
 */
- (NSString *)MD5String {
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
