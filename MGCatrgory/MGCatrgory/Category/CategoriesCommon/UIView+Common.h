//
//  UIView+Common.h
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGestureRecognizer+Common.h"



@interface UIView (Common)

#pragma mark *** 基础方法 **

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize boundsSize;
@property (nonatomic) CGFloat boundsWidth;
@property (nonatomic) CGFloat boundsHeight;


/*
 *  下面6个方法是对center的相关操作
 */
- (void)convertCenterToCenterInRect:(CGRect)rect;
- (void)convertCenterToCenterInRect:(CGRect)rect offset:(UIOffset )offset;  //use UIOffsetMake

- (void)convertCenterToSuperViewCenter;
- (void)convertCenterToSuperViewCenterWithOffset:(UIOffset )offset;

- (void)convertCenterXToSuperViewCenterX;
- (void)convertCenterYToSuperViewCenterY;



/*
 *  下面几个属性是针对 self.layer 快捷操作
 */
@property (nonatomic) IBInspectable CGPoint anchorPoint;
@property (nonatomic) IBInspectable CGFloat anchorPointZ;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, nullable) IBInspectable UIColor *borderColor;
@property (nonatomic, nullable) UIImage *contentImage;
@property (nonatomic) CGRect contentsRect;
@property (nonatomic) CGRect contentsCenter;


/*
 *  下面两个方法设置圆角
 */
- (void)roundedRect:(CGFloat)radius;
- (void)roundedRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor;


#pragma mark *** 视图层级相关 **

- (void)removeAllSubviews;
- (void)addSubviewToBack:(nonnull UIView *)view;

- (void)bringToFront;
- (void)sendToBack;

- (BOOL)isTheFrontSubview;
- (BOOL)isTheBackSubview;

- (BOOL)isSuperviewOfView:(nonnull UIView *)view;
- (BOOL)isSubviewOfView:(nonnull UIView *)view;

- (nullable UIViewController *)firstViewController;


#pragma mark *** 屏幕截图 **

- (nullable UIImage *)capture;


#pragma mark *** 响应相关 **

- (nullable UIView *)firstResponder;
- (void)setAllButtonsExclusiveTouch:(BOOL)exclusiveTouch;


/*
 *  以下属性方法是针对手势的相关设置， 没有处理依赖关系 ， 关闭键盘是用 endEditing： 来实现的
 */
@property (nonatomic, strong, readonly, nullable)  UITapGestureRecognizer *bb_tapGesture;
@property (nonatomic, strong, readonly, nullable) UITapGestureRecognizer *bb_doubleTapGesture;
@property (nonatomic, strong, readonly, nullable) UILongPressGestureRecognizer *bb_longPressGesture;

@property (nonatomic, strong, readonly, nullable) UITapGestureRecognizer *bb_closingKeyboardGesture;

- (nonnull UITapGestureRecognizer *)addTapAction:(nonnull BBGestureActionBlock) actionBlock;
- (nonnull UITapGestureRecognizer *)addDoubleTapAction:(nonnull BBGestureActionBlock) actionBlock;
- (nonnull UILongPressGestureRecognizer *)addLongPressAction:(nonnull BBGestureActionBlock) actionBlock;

- (nonnull UITapGestureRecognizer *)addTapActionForClosingKeyboard;



//  移出到业务
/*
 #pragma mark *** 添加分割图 **
 
 - (void)addHorizontalSpeparatorWithInset:(UIEdgeInsets)inset automaskVertical: (UIViewAutoresizing)mask color:(nullable UIColor *)color;
 - (void)addVerticalSpeparatorWithInset:(UIEdgeInsets)inset automaskVertical: (UIViewAutoresizing)mask color:(nullable UIColor *)color;
 - (void)addTopSeparator;
 - (void)addTopSeparatorWithLeftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset;
 - (void)addBottomSeparator;
 - (void)addBottomSeparatorWithLeftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset;
 - (void)addLeftSeparator;
 - (void)addLeftSeparatorWithTopOffset:(CGFloat)topOffset bottomOffset:(CGFloat)bottomOffset;
 - (void)addRightSeperator;
 - (void)addRightSeperatorWithTopOffset:(CGFloat)topOffset bottomOffset:(CGFloat)bottomOffset;
 
 
 
 #pragma mark - RedDot
 
 @property (nonatomic, strong) UILabel *mt_badgeView;
 @property (nonatomic, strong) UIColor *mt_badgeBackgroundColor;    ///< 默认红色 #ff446a
 @property (nonatomic, strong) UIColor *mt_badgeTitleColor;         ///< 默认白色
 @property (nonatomic, strong) UIFont  *mt_badgeFont;               ///< 默认 18px
 @property (nonatomic, assign) CGRect   mt_badgeFrame;              ///< 默认宽为24px
 @property (nonatomic, assign) CGPoint  mt_badgeCenterOffset;
 @property (nonatomic, assign) NSInteger mt_maximumBadgeNumber;  ///< badgeView可显示的最大值，默认99，超过该值后就显示99+
 
 
 - (void)mt_showRedDotBadgeView;
 - (void)mt_showBadgeViewWithNumber:(NSInteger)number;
 - (void)mt_showBadgeViewWithNumberTitle:(NSString *)title;
 - (void)mt_showBadgeViewWithStringTitle:(NSString *)title;
 - (void)mt_setHidesBadgeView:(BOOL)hidden;
 
 */


@end




