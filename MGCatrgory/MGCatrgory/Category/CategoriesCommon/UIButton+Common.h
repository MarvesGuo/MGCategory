//
//  UIButton+Common.h
//  Pods
//
//  Created by babytree on 28/12/2016.
//
//

#import <UIKit/UIKit.h>


@interface UIButton (Common)


#pragma mark - ** Utilties **

- (void)enlargeWithOffset:(CGFloat)offset;
- (void)enlargeWithEdge:(UIEdgeInsets)inset;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end


