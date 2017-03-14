//
//  UIGestureRecognizer+Common.m
//  
//
//  Created by babytree on 2017/2/24.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import "UIGestureRecognizer+Common.h"
#import <objc/runtime.h>

static const void *s_BBGestureReconizerActionBlockKey = "s_BBGestureReconizerActionBlockKey";


@implementation UIGestureRecognizer (Common)

- (BBGestureActionBlock)actionBlock
{
    return objc_getAssociatedObject(self, s_BBGestureReconizerActionBlockKey);
}


- (void)setActionBlock:(BBGestureActionBlock)actionBlock
{
    objc_setAssociatedObject(self, s_BBGestureReconizerActionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(onGestureCallback:)];
    
    if (actionBlock)
    {
        [self addTarget:self action:@selector(onGestureCallback:)];
    }
}


- (void)onGestureCallback:(UIGestureRecognizer *)sender
{
    BBGestureActionBlock block = [self actionBlock];
    
    if ([self isKindOfClass: [UILongPressGestureRecognizer class]])
    {
      if (self.state == UIGestureRecognizerStateBegan)
      {
          if (block)
          {
              block(sender);
          }
      }
    }
    else
    {
        if (block)
        {
            block(sender);
        }
    }
}

@end
