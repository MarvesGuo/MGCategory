//
//  MTPlaceholderTextView.h
//  
//
//  Created by babytree on 2017/2/27.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 *  带placeholder的Label  默认color是UITextField 系统默认颜色，字体随TextView
 */

@interface MTPlaceholderTextView : UITextView

@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;


@end
