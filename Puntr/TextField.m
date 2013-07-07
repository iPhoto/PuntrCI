//
//  TextField.m
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextField

- (void)setBackground:(UIImage *)background {
    [super setBackground:background];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
}

- (void)setVerticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment {
    [super setContentVerticalAlignment:verticalAlignment];
}

- (void)setHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment {
    [super setContentHorizontalAlignment:horizontalAlignment];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    [super setClearButtonMode:clearButtonMode];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self rect:bounds leftOffset:14.0f rightOffset:0.0f];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self rect:bounds leftOffset:14.0f rightOffset:25.0f];
}

- (CGRect)rect:(CGRect)rect leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset {
    CGRect resultRect = rect;
    resultRect.origin.x += leftOffset;
    resultRect.size.width -= leftOffset + rightOffset;
    return resultRect;
}

@end
