//
//  TextField.h
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextField : UITextField

- (void)setBackground:(UIImage *)background UI_APPEARANCE_SELECTOR;
- (void)setBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setFont:(UIFont *)font UI_APPEARANCE_SELECTOR;
- (void)setVerticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment UI_APPEARANCE_SELECTOR;
- (void)setHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment UI_APPEARANCE_SELECTOR;
- (void)setTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode UI_APPEARANCE_SELECTOR;
- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;
- (void)setBorderWidth:(CGFloat)borderWidth UI_APPEARANCE_SELECTOR;
- (void)setBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

@end
