//
//  UIImageView+Common.m
//  
//
//  Created by babytree on 2017/2/13.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import "UIImageView+Common.h"
#import "UIImage+Common.h"
#import "NSArray+Common.h"


@implementation UIImageView (Common)


+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (UIImageView *)imageViewWithStretchableImage:(NSString *)imageName frame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [[UIImage imageNamed:imageName] stretchableImageWithCenter];
    
    return imageView;
}

+ (UIImageView *)imageViewWithImageArray:(NSArray<NSString *> *)imageArray duration:(NSTimeInterval)duration {
    
    NSArray<UIImage *> *mappedArray = [imageArray flatMappedArrayUsingBlock:^id _Nonnull(NSString * _Nonnull object) {
        return [UIImage imageNamed:object];
    }];
    
    if (mappedArray.count == 0)
        return nil;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:mappedArray.firstObject];
    imageView.animationImages = mappedArray;
    imageView.animationDuration = duration;
    
    return imageView;
}


@end

