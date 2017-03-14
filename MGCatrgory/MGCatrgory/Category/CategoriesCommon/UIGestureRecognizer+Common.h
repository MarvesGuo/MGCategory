//
//  UIGestureRecognizer+Common.h
//  
//
//  Created by babytree on 2017/2/24.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^BBGestureActionBlock)(UIGestureRecognizer *sender);


@interface UIGestureRecognizer (Common)


@property(nonatomic, copy) BBGestureActionBlock actionBlock;



@end
