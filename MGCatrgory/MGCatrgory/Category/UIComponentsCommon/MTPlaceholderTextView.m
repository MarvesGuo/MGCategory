//
//  MTPlaceholderTextView.m
//
//
//  Created by babytree on 2017/2/27.
//  Copyright © 2017年 babytree. All rights reserved.
//

#import "MTPlaceholderTextView.h"


@interface MTPlaceholderTextView ()
{
    UILabel * _placeholderLabel;
}

@end


@implementation MTPlaceholderTextView


#pragma mark - ** placeholder 相关 **


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (self.placeholderLabel)
    {
        for (NSString *key in self.class.observingKeys)
        {
            @try
            {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception)
            {
                // Do nothing
            }
        }
    }
}




//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self s_updatePlaceholderLabel];
}

- (void)s_updatePlaceholderLabel
{
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    
    [self insertSubview:self.placeholderLabel atIndex:0];
    
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;
    
    UIEdgeInsets textContainerInset = self.textContainerInset;
    
    CGFloat x = textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x+5, y, width-5, height);
}






#pragma mark - Getter/Setter

- (UILabel *)placeholderLabel
{
    
    if (!_placeholderLabel) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [self.class defaultPlaceholderColor];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(s_updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        for (NSString *key in self.class.observingKeys)
        {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return _placeholderLabel;
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    [self s_updatePlaceholderLabel];
}

- (NSAttributedString *)attributedPlaceholder
{
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self s_updatePlaceholderLabel];
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}



#pragma mark - Utilities

+ (UIColor *)defaultPlaceholderColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        //be careful here, might be broken if apple decide to change name
        color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    });
    return color;
}

+ (NSArray *)observingKeys
{
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"];
}


@end
