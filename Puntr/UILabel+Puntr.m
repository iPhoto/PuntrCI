//
//  UILabel+Puntr.m
//  Puntr
//
//  Created by Eugene Tulushev on 28.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UILabel+Puntr.h"

@implementation UILabel (Puntr)

+ (UILabel *)labelSmallBold:(BOOL)bold black:(BOOL)black
{
    UILabel *label = [[UILabel alloc] init];
    label.font = bold ? [UIFont fontWithName:@"Arial-BoldMT" size:12.0f] : [UIFont fontWithName:@"ArialMT" size:10.4f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = black ? [UIColor whiteColor] : [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    return label;
}

@end
