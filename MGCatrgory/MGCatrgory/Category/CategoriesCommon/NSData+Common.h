//
//  NSData+Common.h
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Common)

#pragma mark - ** Coding **

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedString;

- (NSString *)MD5String;

@end
