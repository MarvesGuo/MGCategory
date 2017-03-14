//
//  NSNumber+Common.m
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "NSNumber+Common.h"

@implementation NSNumber (Common)


#pragma - **Safe Methods**
- (BOOL)safe_isEqualToNumber: (nullable NSNumber *)otherNumber {
    return (otherNumber && [otherNumber isKindOfClass:[NSNumber class]])? [self isEqualToNumber:otherNumber] : NO;
}

- (NSComparisonResult)safe_compare:(nullable NSNumber *)otherNumber {
    return (otherNumber && [otherNumber isKindOfClass:[NSNumber class]])? [self compare:otherNumber] : NSOrderedDescending;
}


@end
