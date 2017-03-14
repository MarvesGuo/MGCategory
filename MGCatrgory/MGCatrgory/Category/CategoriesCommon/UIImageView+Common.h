//
//  UIImageView+Common.h
//  
//
//  Created by babytree on 2017/2/13.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (Common)

+ (nonnull UIImageView *)imageViewWithImageNamed:(nonnull NSString *)imageName;
+ (nonnull UIImageView *)imageViewWithStretchableImage:(nonnull NSString *)imageName frame:(CGRect)frame;
+ (nullable UIImageView *)imageViewWithImageArray:(nonnull NSArray<NSString *> *)imageArray duration:(NSTimeInterval)duration;

@end
