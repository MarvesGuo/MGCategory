//
//  NSMutableArray+Common.h
//
//
//  Created by babytree on 21/02/2017.
//  Copyright © 2017 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Common)


#pragma mark - ** GeneralMethods **

- (void)moveObjectToTopAtIndex:(NSUInteger)index;
- (void)moveObjectFromIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex;
- (void)removeFirstObject;
- (nullable id)pop;

#pragma mark - ** Safe **

- (void)safe_addObject: (nullable id)object;
- (void)safe_insertObject:(nullable id)object atIndex:(NSUInteger)index;

@end
