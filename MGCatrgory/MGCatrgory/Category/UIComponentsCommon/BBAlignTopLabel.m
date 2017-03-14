//
//  BBAlignTopLabel.m
//  
//
//  Created by babytree on 2017/2/27.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import "BBAlignTopLabel.h"

@implementation BBAlignTopLabel

- (void)drawTextInRect:(CGRect)rect
{
    CGSize sizeThatFits = [self sizeThatFits:rect.size];
    rect.size.height = MIN(rect.size.height, sizeThatFits.height);
    
    [super drawTextInRect:rect];
}

@end
