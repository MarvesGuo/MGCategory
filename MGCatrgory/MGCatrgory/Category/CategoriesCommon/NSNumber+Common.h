//
//  NSNumber+Common.h
//
//
//  Created by babytree on 21/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Common)


#pragma mark - ** Safe Methods **

- (BOOL)safe_isEqualToNumber: (nullable NSNumber *)otherNumber;
- (NSComparisonResult)safe_compare:(nullable NSNumber *)otherNumber;


@end
