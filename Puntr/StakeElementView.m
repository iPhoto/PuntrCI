//
//  StakeElementView.m
//  Puntr
//
//  Created by Eugene Tulushev on 19.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "StakeElementView.h"
#import <QuartzCore/QuartzCore.h>

@interface StakeElementView ()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelResult;

@property (nonatomic, strong) UIButton *button;

@end

@implementation StakeElementView

- (void)loadWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f].CGColor;
    self.layer.borderWidth = 1.0f;
    
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    UIColor *textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    
    CGFloat titlePadding = 10.0f;
    CGFloat resultPadding = 28.0f;
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(titlePadding, 0.0f, CGRectGetWidth(self.frame) - (titlePadding + resultPadding), CGRectGetHeight(self.frame))];
    self.labelTitle.font = font;
    self.labelTitle.backgroundColor = [UIColor clearColor];
    self.labelTitle.textColor = textColor;
    self.labelTitle.text = title;
    [self.labelTitle sizeToFit];
    self.labelTitle.frame = CGRectSetHeight(self.labelTitle.frame, CGRectGetHeight(self.frame));
    [self addSubview:self.labelTitle];
    
    self.labelResult = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.labelTitle.frame), 0.0f, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.labelTitle.frame) + resultPadding), CGRectGetHeight(self.frame))];
    self.labelResult.font = font;
    self.labelResult.backgroundColor = [UIColor clearColor];
    self.labelResult.textAlignment = NSTextAlignmentRight;
    self.labelResult.textColor = [UIColor colorWithRed:0.20f green:0.40f blue:0.60f alpha:1.00f];
    self.labelResult.text = @"";
    [self addSubview:self.labelResult];
    if(target && action)
    {
        CGFloat arrowViewWidth = 25.0f;
        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - arrowViewWidth, 0.0f, arrowViewWidth, CGRectGetHeight(self.frame))];
        imageViewArrow.image = [UIImage imageNamed:@"IconArrow"];
        imageViewArrow.contentMode = UIViewContentModeCenter;
        [self addSubview:imageViewArrow];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = self.bounds;
        [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
    }
}

- (void)updateResult:(NSString *)result
{
    self.labelResult.text = result;
}

@end
