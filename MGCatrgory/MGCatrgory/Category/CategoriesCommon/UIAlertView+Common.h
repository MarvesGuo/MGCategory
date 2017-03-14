//
//  UIAlertView+Common.h
//
//
//  Created by babytree on 2017/2/13.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIAlertController+Common.h"


#define BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE @"确定"          /* 默认显示的文案 */
#define BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE @"取消"

typedef void (^BBAlertClickedButtonBlock)(  UIAlertView * _Nonnull alertView, NSUInteger buttonIndex);



@interface UIAlertView (Common)


#pragma mark - ** Block相关 **

@property (nonatomic, copy, nonnull) BBAlertClickedButtonBlock  bb_clickedButtonBlock;           /* 点击按钮的回调 */


/*
 * 下面3个方法，无title 只有message。默认是取消、确定按钮都出现。 没有Block回调
 */
+ (nonnull UIAlertView *)showWithMessage:(nullable NSString *)message;
+ (nonnull UIAlertView *)showOkWithMessage:(nullable NSString *)message;
+ (nonnull UIAlertView *)showCancelWithMessage:(nullable NSString *)message;


/*
 * 下面3个方法，有title 有message。默认是取消、确定按钮都出现。 没有Block回调
 */
+ (nonnull UIAlertView *)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (nonnull UIAlertView *)showOkWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (nonnull UIAlertView *)showCancelWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/*
 * 下面3个方法，有title 有message。默认是取消、确定按钮都出现。 有Block回调
 */
+ (nonnull UIAlertView *)showWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                         block:(nullable BBAlertClickedButtonBlock)block;
+ (nonnull UIAlertView *)showOkWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
                           block:(nullable BBAlertClickedButtonBlock)block;
+ (nonnull UIAlertView *)showCancelWithTitle:(nullable NSString *)title
                             message:(nullable NSString *)message
                               block:(nullable BBAlertClickedButtonBlock)block;

/*
 * 同上根据传入参数判断取舍
 */
+ (nonnull UIAlertView *)showWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                         block:(nullable BBAlertClickedButtonBlock)block
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                  buttonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


@end


