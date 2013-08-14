//
//  MyStakesViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "MyStakesViewController.h"
#import "UIViewController+Puntr.h"

@interface MyStakesViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation MyStakesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Мои ставки";
    [self addBalanceButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Ставки", @"Пари"]];
    self.segmentedControl.frame = CGRectMake(15.0f, 11, 290.0f, 31.0f);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor blackColor];
    [self.view addSubview:self.segmentedControl];
    dispatch_async(dispatch_get_main_queue(), ^
        {
            self.segmentedControl.selectedSegmentIndex = 1;
        }
    );
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
}

@end
