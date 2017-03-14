//
//  NSURL+Common.m
//
//
//  Created by babytree on 2017/2/8.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import "NSURL+Common.h"

@implementation NSURL (Common)


#pragma mark - **Properties**
/**
 URL 字符数

 @return URL 字符数
 */
- (NSUInteger)length {
    return [[self absoluteString] length];
}


#pragma mark - **Utils**
/**
 通过 key，找到 query 的值
 
 @param key key
 @return value or nil if not found
 */
- (NSString *)queryArgumentForKey:(NSString *)key {
    for (NSString *obj in [[self query] componentsSeparatedByString:@"&"]) {
        NSArray *keyAndValue = [obj componentsSeparatedByString:@"="];
        
        if (([keyAndValue count] >= 2) && ([[keyAndValue objectAtIndex:0] caseInsensitiveCompare:key] == NSOrderedSame)) {
            return [keyAndValue objectAtIndex:1];
        }
    }
    
    return nil;
}


/**
 判断是否相等，参考做法 http://vgable.com/blog/2009/04/22/nsurl-isequal-gotcha/

 @param otherURL otherURL
 @return YES or NO
 */
- (BOOL)isEqualToURL:(NSURL*)otherURL {
    return [[self absoluteURL] isEqual:[otherURL absoluteURL]] ||
    ([self isFileURL] && [otherURL isFileURL] && [[self path] isEqual:[otherURL path]]);
}


@end
