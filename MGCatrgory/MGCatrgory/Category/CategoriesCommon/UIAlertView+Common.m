//
//  UIAlertView+Common.m
//  MeiTunTools
//
//  Created by babytree on 2017/2/13.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import "UIAlertView+Common.h"
#import <objc/runtime.h>


static const void *s_alertViewCommonPrivateAlertViewKey = "s_alertViewCommonPrivateAlertViewKey";
//static const void *s_alertViewCommonOriginalDelegateKey = "s_alertViewCommonOriginalDelegateKey";


@implementation UIAlertView (Common)


- (BBAlertClickedButtonBlock)bb_clickedButtonBlock
{
    return objc_getAssociatedObject(self, s_alertViewCommonPrivateAlertViewKey);
}

- (void)setBb_clickedButtonBlock:(BBAlertClickedButtonBlock)bb_clickedButtonBlock
{
    [self s_checkAlertViewDelegate];
    objc_setAssociatedObject(self, s_alertViewCommonPrivateAlertViewKey, bb_clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}


/**
 *  无标题，只有提示和取消、确定按钮
 *
 */
+ (UIAlertView *)showWithMessage:(NSString *)message
{

    UIAlertView * showAlertView =[self showWithTitle:nil
                                             message:message
                                               block:nil
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE
                                        buttonTitles:BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE, nil];
    return showAlertView;
}

/**
 *  无标题，只有确定按钮和提示
 *
 */
+ (UIAlertView *)showOkWithMessage:(NSString *)message
{
    UIAlertView * showAlertView =[self showWithTitle:nil
                                             message:message
                                               block:nil
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE
                                        buttonTitles:nil];
    return showAlertView;
}

/**
 *  无标题，只有取消按钮和提示
 *
 */
+ (UIAlertView *)showCancelWithMessage:(NSString *)message
{
    UIAlertView * showAlertView =[self showWithTitle:nil
                                             message:message
                                               block:nil
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE
                                        buttonTitles:nil];
    return showAlertView;
}

/**
 *  带标题，提示语和确定、取消
 *
 */
+ (UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * showAlertView =[self showWithTitle:title
                                             message:message
                                               block:nil
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE
                                        buttonTitles:BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE, nil];
    return showAlertView;
}

/**
 *  带标题，提示语和确定按钮
 *
 */
+ (UIAlertView *)showOkWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * showAlertView =[self showWithTitle:title
                                             message:message
                                               block:nil
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE
                                        buttonTitles:nil];
    return showAlertView;
}

/**
 *  带标题，提示语和取消按钮
 *
 */
+ (UIAlertView *)showCancelWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * showAlertView =[self showWithTitle:title
                                             message:message
                                               block:nil
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE
                                        buttonTitles:nil];
    return showAlertView;
}

/**
 *  显示标题、提示语、带确定、取消按钮
 */
+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                         block:(BBAlertClickedButtonBlock)block
{
    UIAlertView * showAlertView =[self showWithTitle:title
                                             message:message
                                               block:block
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE
                                        buttonTitles:BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE, nil];
    return showAlertView;
}

/**
 *  显示标题、提示语、带确定按钮
 *
 */
+ (UIAlertView *)showOkWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
                           block:(nullable BBAlertClickedButtonBlock)block
{
    UIAlertView * showAlertView =[self showWithTitle:title
                                             message:message
                                               block:block
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_OK_BUTTON_TITLE
                                        buttonTitles:nil];
    return showAlertView;
}

/**
 *  显示标题、提示语、带取消按钮
 *
 */
+ (UIAlertView *)showCancelWithTitle:(NSString *)title
                             message:(NSString *)message
                               block:(BBAlertClickedButtonBlock)block
{
    UIAlertView * showAlertView =[self showWithTitle:title
                                             message:message
                                               block:block
                                   cancelButtonTitle:BB_COMMON_ALERT_VIEW_CANCEL_BUTTON_TITLE
                                        buttonTitles:nil];
    return showAlertView;
}

/**
 *  显示标题、提示语、输入按钮按钮
 */
+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                         block:(BBAlertClickedButtonBlock)block
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                  buttonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:[UIApplication sharedApplication]
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitles, nil];
    alertView.bb_clickedButtonBlock = block;
    [alertView show];
    
    return alertView;
}

#pragma mark - UITAlertViewDelegate


- (void) s_checkAlertViewDelegate {
    if (self.delegate != (id<UIAlertViewDelegate>)self)
    {
//        objc_setAssociatedObject(self, s_alertViewCommonOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.bb_clickedButtonBlock)
    {
        alertView.bb_clickedButtonBlock(alertView, buttonIndex);
    }
//    id originalDelegate = objc_getAssociatedObject(self, s_alertViewCommonOriginalDelegateKey);
//    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
//    {
//        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
//    }
}



@end
