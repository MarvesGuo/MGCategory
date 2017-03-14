//
//  NSURL+Common.h
//
//
//  Created by babytree on 2017/2/8.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Common)


#pragma mark - ** Properties **

@property (readonly, nonatomic) NSUInteger length;


#pragma mark - ** Utilties **

- (NSString *)queryArgumentForKey:(NSString *)key;
- (BOOL)isEqualToURL:(NSURL *)otherURL;

@end
