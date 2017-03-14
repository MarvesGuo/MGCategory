//
//  UITextView+Common.m
//  
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "UITextView+Common.h"

@implementation UITextView (Common)


- (CGFloat)heightWithMaxWidth:(CGFloat)width
{
    CGSize sizeToFit = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}


@end


