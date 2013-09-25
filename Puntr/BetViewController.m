//
//  BetViewController.m
//  Puntr
//
//  Created by Artem on 9/25/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "BetViewController.h"
#import "UILabel+Puntr.h"


@interface BetViewController ()

@end

@implementation BetViewController

- (id)init {
    if (self = [self initWithNibName:nil bundle:nil]) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat coverMargin = 8.0f;
    
    self.view.frame = CGRectMake(0.0f, 0.0f, 300.0f, 280.0f);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    UIFont *titleFont = [UIFont fontWithName:@"Arial-BoldMT" size:14.0f];
    UILabel *controllerTitleLabel = [UILabel labelSmallBold:YES black:YES];
    controllerTitleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    controllerTitleLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    controllerTitleLabel.font = titleFont;
    controllerTitleLabel.textColor = [UIColor whiteColor];
    controllerTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    controllerTitleLabel.numberOfLines = 0;
    controllerTitleLabel.contentMode = UIViewContentModeCenter;
    controllerTitleLabel.textAlignment = NSTextAlignmentCenter;
    controllerTitleLabel.text = @"Пари";
    [self.view addSubview:controllerTitleLabel];
}

@end
