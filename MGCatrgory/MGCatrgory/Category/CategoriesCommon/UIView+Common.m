//
//  UIView+Common.m
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>





static const void *s_BBViewTapGestureKey = "s_BBViewTapGestureKey";
static const void *s_BBViewDoubleTapGestureKey = "s_BBViewDoubleTapGestureKey";
static const void *s_BBViewLongPressGestureKey = "s_BBViewLongPressGestureKey";
static const void *s_BBViewTapGestureForClosingKeyboardKey = "s_BBViewTapGestureForClosingKeyboardKey";



@implementation UIView (Common)

#pragma mark *** 基础方法 **


- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


/**
 *  修改视图左边界的位置，宽高不变
 *
 */
- (CGFloat)left;
{
    return CGRectGetMinX([self frame]);
}

- (void)setLeft:(CGFloat)x;
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

/**
 *  修改视图右边界的位置，宽高不变
 *
 */
- (CGFloat)right;
{
    return CGRectGetMaxX([self frame]);
}

- (void)setRight:(CGFloat)right;
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

/**
 *  修改视图上边界的位置，宽高不变
 *
 */
- (CGFloat)top
{
    return CGRectGetMinY([self frame]);
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/**
 *  修改视图下边界的位置，宽高不变
 *
 */
- (CGFloat)bottom;
{
    return CGRectGetMaxY([self frame]);
}

- (void)setBottom:(CGFloat)bottom;
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width
{
    self.size = CGSizeMake(width, self.size.height);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height
{
    self.size = CGSizeMake(self.size.width, height);
}

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight
{
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}


/**
 *  修改center 相对父视图的Rect
 *
 */
- (void)convertCenterToCenterInRect:(CGRect)rect
{
    self.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/**
 *  修改center 相对父视图的Rect offset 是相对中心位置的
 *
 */
- (void)convertCenterToCenterInRect:(CGRect)rect offset:(UIOffset )offset
{
    self.center = CGPointMake(CGRectGetMidX(rect) + offset.horizontal, CGRectGetMidY(rect) + offset.vertical);
}


- (void)convertCenterToSuperViewCenter
{
    [self convertCenterToCenterInRect: self.superview.bounds];
}

- (void)convertCenterToSuperViewCenterWithOffset:(UIOffset )offset
{
    [self convertCenterToCenterInRect:self.superview.bounds offset: offset];
    
}

- (void)convertCenterXToSuperViewCenterX
{
    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), self.centerY);
}

- (void)convertCenterYToSuperViewCenterY
{
    self.center = CGPointMake(self.centerX, CGRectGetMidY(self.superview.bounds));
}



/**
 *  self.layer的 anchorPoint
 *
 */
- (CGPoint)anchorPoint
{
    return self.layer.anchorPoint;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    self.layer.anchorPoint = anchorPoint;
}

/**
 *  self.layer的 anchorPointZ
 *
 */
- (CGFloat)anchorPointZ
{
    return self.layer.anchorPointZ;
}

- (void)setAnchorPointZ:(CGFloat)anchorPointZ
{
    self.layer.anchorPointZ = anchorPointZ;
}

/**
 *  self.layer的 cornerRadius
 *
 */
- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    if (fabs(cornerRadius - 0.0) > FLT_EPSILON && !self.layer.masksToBounds)
        self.layer.masksToBounds = YES;
}

/**
 *  self.layer的 borderWidth
 *
 */
- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

/**
 *  self.layer的 borderColor
 *
 */
- (nullable UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(nullable UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

/**
 *  self.layer的 contentImage
 *
 */
- (nullable UIImage *)contentImage
{
    return [UIImage imageWithCGImage:(CGImageRef)self.layer.contents];
}

- (void)setContentImage:(nullable UIImage *)contentImage
{
    self.layer.contents = (__bridge id)contentImage.CGImage;
}

/**
 *  self.layer的 contentsRect
 *
 */
- (CGRect)contentsRect
{
    return self.layer.contentsRect;
}

- (void)setContentsRect:(CGRect)contentsRect
{
    self.layer.contentsRect = contentsRect;
}

- (CGRect)contentsCenter
{
    return self.layer.contentsCenter;
}

- (void)setContentsCenter:(CGRect)contentsCenter
{
    self.layer.contentsCenter = contentsCenter;
}

/**
 *  self.layer 设置圆角
 *
 */
- (void)roundedRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor
{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}

- (void)roundedRect:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

#pragma mark *** 视图层级相关 **

/**
 *  移除所有子视图
 *
 */
- (void)removeAllSubviews
{
    while (self.subviews.count > 0)
    {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

/**
 *  添加子视图到最后
 *
 */
- (void)addSubviewToBack:(UIView *)view
{
    [self addSubview:view];
    [self sendSubviewToBack:view];
}

/**
 *  视图移动到最前面
 *
 */
- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

/**
 *  视图移动到最后
 *
 */
- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

/**
 *  是否是顶视图
 *
 */
- (BOOL)isTheFrontSubview
{
    return (self.superview.subviews.lastObject == self);
}

/**
 *  是否是底视图
 *
 */
- (BOOL)isTheBackSubview
{
    return ([self.superview.subviews objectAtIndex:0] == self);
}

/**
 *  是否是传入视图的父视图
 *
 */
- (BOOL)isSuperviewOfView:(UIView *)view
{
    return [view.superview.subviews containsObject:self];
}

/**
 *  是否是传入视图的子视图
 *
 */
- (BOOL)isSubviewOfView:(UIView *)view
{
    return [view.subviews containsObject:view];
}

/**
 *  根据响应链找到第一个找到的 viewController
 *
 */
- (nullable UIViewController *)firstViewController
{
    id responder = self;
    
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return responder;
        }
    }
    
    return nil;
}


#pragma mark *** 屏幕截图 **

/**
 *  view截图，图片大小是当前View的大小
 *
 */
- (nullable UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}



#pragma mark *** 响应相关 **

/**
 *  找到 first responder 的View
 *
 */
- (nullable UIView *)firstResponder
{
    if ([self isFirstResponder])
    {
        return self;
    }
    
    for (UIView *view in self.subviews)
    {
        UIView *firstResponder = [view firstResponder];
        if (firstResponder != nil)
        {
            return firstResponder;
        }
    }
    return nil;
}

/**
 *  设置视图层级，所有子视图的exclusiveTouch属性，包括子视图所有的subview
 *
 */
- (void)setAllButtonsExclusiveTouch:(BOOL)exclusiveTouch
{
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            subview.exclusiveTouch = YES;
        }
        else if([subview isKindOfClass:[UIView class]])
        {
            [subview setAllButtonsExclusiveTouch:exclusiveTouch];
        }
    }
}



#pragma mark --  手势相关


/**
 *  单击手势
 *
 */
- (nullable UITapGestureRecognizer *)bb_tapGesture
{
    return objc_getAssociatedObject(self, s_BBViewTapGestureKey);
}

- (void)setBb_tapGesture:(nullable UITapGestureRecognizer * )bb_tapGesture {
    if (bb_tapGesture == nil)
    {
        self.bb_tapGesture.actionBlock = nil;
        
        if (self.bb_tapGesture)
        {
            [self removeGestureRecognizer:self.bb_tapGesture];
        }
    }
    
    objc_setAssociatedObject(self, s_BBViewTapGestureKey, bb_tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  双击手势
 *
 */
- (nullable UITapGestureRecognizer *)bb_doubleTapGesture
{
    return objc_getAssociatedObject(self, s_BBViewDoubleTapGestureKey);
}

- (void)setBb_doubleTapGesture:(nullable UITapGestureRecognizer *)bb_doubleTapGesture
{
    if (bb_doubleTapGesture == nil)
    {
        self.bb_doubleTapGesture.actionBlock = nil;
        
        if (self.bb_doubleTapGesture)
        {
            [self removeGestureRecognizer:self.bb_doubleTapGesture];
        }
    }
    
    objc_setAssociatedObject(self, s_BBViewDoubleTapGestureKey, bb_doubleTapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  长按手势
 *
 */
- (nullable UILongPressGestureRecognizer *)bb_longPressGesture
{
    return objc_getAssociatedObject(self, s_BBViewLongPressGestureKey);
}

- (void)setBb_longPressGesture:(nullable UILongPressGestureRecognizer *)bb_longPressGesture
{
    if (bb_longPressGesture == nil)
    {
        self.bb_longPressGesture.actionBlock = nil;
        
        if (self.bb_longPressGesture)
        {
            [self removeGestureRecognizer:self.bb_longPressGesture];
        }
    }
    
    objc_setAssociatedObject(self, s_BBViewLongPressGestureKey, bb_longPressGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  关闭键盘手势
 *
 */
- (nullable UITapGestureRecognizer *)bb_closingKeyboardGesture
{
    return objc_getAssociatedObject(self, s_BBViewTapGestureForClosingKeyboardKey);
}

-(void)setBb_closingKeyboardGesture:(nullable UITapGestureRecognizer * )bb_closingKeyboardGesture
{
    if (bb_closingKeyboardGesture == nil)
    {
        self.bb_closingKeyboardGesture.actionBlock = nil;
        
        if (self.bb_closingKeyboardGesture)
        {
            [self removeGestureRecognizer:self.bb_closingKeyboardGesture];
        }
    }
    
    objc_setAssociatedObject(self, s_BBViewTapGestureForClosingKeyboardKey, bb_closingKeyboardGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  添加单击手势
 *
 */
- (UITapGestureRecognizer *)addTapAction:(BBGestureActionBlock) actionBlock
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture;
    
    if (self.bb_tapGesture)
    {
        self.bb_tapGesture.actionBlock = actionBlock;
    }
    else
    {
        tapGesture = [[UITapGestureRecognizer alloc] init];
        tapGesture.actionBlock = actionBlock;
        [self addGestureRecognizer:tapGesture];
        self.bb_tapGesture = tapGesture;
    }
    return tapGesture;
}

/**
 *  添加双击手势
 *
 */
- (UITapGestureRecognizer *)addDoubleTapAction:(BBGestureActionBlock) actionBlock
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleTapGesture;
    
    if (self.bb_doubleTapGesture)
    {
        self.bb_doubleTapGesture.actionBlock = actionBlock;
    }
    else
    {
        doubleTapGesture = [[UITapGestureRecognizer alloc] init];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.actionBlock = actionBlock;
        [self addGestureRecognizer:doubleTapGesture];
        self.bb_doubleTapGesture = doubleTapGesture;
    }
    return doubleTapGesture;
}

/**
 *  添加长按手势
 *
 */
- (UILongPressGestureRecognizer *)addLongPressAction:(BBGestureActionBlock) actionBlock
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGesture;
    
    if (self.bb_longPressGesture)
    {
        self.bb_longPressGesture.actionBlock = actionBlock;
    }
    else
    {
        longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        longPressGesture.actionBlock = actionBlock;
        [self addGestureRecognizer:longPressGesture];
        self.bb_longPressGesture = longPressGesture;
    }
    return longPressGesture;
}

/**
 *  添加关闭键盘手势  默认事件是 [self endEditing：YES]
 *
 */
- (UITapGestureRecognizer *)addTapActionForClosingKeyboard
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture;
    
    if (self.bb_closingKeyboardGesture)
    {
        return  self.bb_closingKeyboardGesture;
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        tapGesture = [[UITapGestureRecognizer alloc] init];
        tapGesture.actionBlock = ^(UIGestureRecognizer *sender)
        {
            [weakSelf endEditing:YES];
        };;
        [self addGestureRecognizer:tapGesture];
        self.bb_closingKeyboardGesture = tapGesture;
    }
    return tapGesture;
}

@end





