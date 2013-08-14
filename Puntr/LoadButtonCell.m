//
//  LoadButtonCell.m
//  Puntr
//
//  Created by Alexander Lebedev on 7/24/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LoadButtonCell.h"


@interface LoadButtonCell ()

@property (nonatomic) BOOL loaded;
@property (nonatomic, strong) UIImageView *imageViewTopLine;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LoadButtonCell


- (void)loadButton
{
    if (!self.loaded)
    {
        self.imageViewTopLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        [self addSubview:self.imageViewTopLine];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, self.frame.size.width - 20, 40)];
        [self.button setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkLong"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)] forState:UIControlStateNormal];
        [self.button setTitle:@"Загрузить больше" forState:UIControlStateNormal];
        [self.button.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
        self.button.titleLabel.shadowColor = [UIColor blackColor];
        self.button.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
        [self.button.titleLabel setTextColor:[UIColor whiteColor]];
        self.button.userInteractionEnabled = NO;
        [self addSubview:self.button];
        
        self.loaded = YES;
    }
}

@end
