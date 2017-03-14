//
//  UIButton+Common.m
//  Pods
//
//  Created by babytree on 28/12/2016.
//
//

#import <objc/runtime.h>
#import "UIButton+Common.h"
#import "UIColor+Common.h"
#import "UIView+Common.h"
#import "NSObject+Common.h"


@interface UIButton (Private)

@property (nonatomic, assign) BOOL needLayoutForChangeStyle;

@end



@implementation UIButton (Common)


#pragma mark - **Utils**
static char insetNameKey;

/**
 扩大按钮点击区域
 
 @param offset 上下左右扩大的距离
 */
- (void)enlargeWithOffset:(CGFloat)offset {
    [self enlargeWithEdge: UIEdgeInsetsMake(offset, offset, offset, offset)];
}


/**
 根据 state 设置背景颜色
 
 使用 Image 的方式实现

 @param backgroundColor 颜色
 @param state 状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self setBackgroundImage:image forState:state];
}


/**
 扩大按钮点击区域
 
 @param inset 扩大距离
 */
- (void)enlargeWithEdge:(UIEdgeInsets)inset {
    objc_setAssociatedObject(self, &insetNameKey, [NSValue valueWithUIEdgeInsets:inset], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)_enlargedRect {
    NSValue *insetValue = objc_getAssociatedObject(self, &insetNameKey);
    
    if (insetValue) {
        UIEdgeInsets inset = [insetValue UIEdgeInsetsValue];
        return CGRectMake(self.bounds.origin.x - inset.left,
                          self.bounds.origin.y - inset.top,
                          self.bounds.size.width + inset.left + inset.right,
                          self.bounds.size.height + inset.top + inset.bottom);
    }
    
    return self.bounds;
}

//CAUSION: overwrite system method is an undefined behavor.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self _enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
        return [super hitTest:point withEvent:event];
    
    return CGRectContainsPoint(rect, point) ? self : nil;
}


@end
