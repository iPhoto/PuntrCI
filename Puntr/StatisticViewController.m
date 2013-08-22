//
//  StatisticViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/22/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "StatisticViewController.h"
#import "StakeElementView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat TNItemSpacing = 8.0f;

@interface StatisticViewController ()

@property (nonatomic, strong) UIView *viewTextFieldsBackground;

@property (strong, nonatomic) StakeElementView *stakeCount;
@property (strong, nonatomic) StakeElementView *wins;
@property (strong, nonatomic) StakeElementView *loose;
@property (strong, nonatomic) StakeElementView *maxWin;
@property (strong, nonatomic) StakeElementView *favouriteTeam;

@end

@implementation StatisticViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Статистика";
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGFloat stakeElementHeight = 40.0f;
    CGFloat screenWidth = CGRectGetWidth(viewControllerFrame);

    self.viewTextFieldsBackground = [[UIView alloc] initWithFrame:CGRectMake(TNItemSpacing, TNItemSpacing, screenWidth - TNItemSpacing * 2.0f, 200.0f)];
    self.viewTextFieldsBackground.backgroundColor = [UIColor whiteColor];
    self.viewTextFieldsBackground.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.viewTextFieldsBackground];
            
    self.stakeCount = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                         TNItemSpacing * 2.0f,
                                                                         TNItemSpacing * 2.0f,
                                                                         screenWidth - TNItemSpacing * 4.0f,
                                                                         stakeElementHeight
                                                                        )];
    [self.stakeCount loadWithTitle:@"Сделал ставок:" target:nil action:nil];
    [self.view addSubview:self.stakeCount];
    
	self.wins = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                         TNItemSpacing * 2.0f,
                                                                         CGRectGetMaxY(self.stakeCount.frame) + TNItemSpacing,
                                                                         screenWidth - TNItemSpacing * 4.0f,
                                                                         stakeElementHeight
                                                                        )];
    [self.wins loadWithTitle:@"Выиграл:" target:nil action:nil];
    [self.view addSubview:self.wins];
    
    self.loose = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                   TNItemSpacing * 2.0f,
                                                                   CGRectGetMaxY(self.wins.frame) + TNItemSpacing,
                                                                   screenWidth - TNItemSpacing * 4.0f,
                                                                   stakeElementHeight
                                                                   )];
    [self.loose loadWithTitle:@"Проиграл:" target:nil action:nil];
    [self.view addSubview:self.loose];
    
    self.maxWin = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                   TNItemSpacing * 2.0f,
                                                                   CGRectGetMaxY(self.loose.frame) + TNItemSpacing,
                                                                   screenWidth - TNItemSpacing * 4.0f,
                                                                   stakeElementHeight
                                                                   )];
    [self.maxWin loadWithTitle:@"Максимальный выигрыш:" target:nil action:nil];
    [self.view addSubview:self.maxWin];
    
    self.favouriteTeam = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                   TNItemSpacing * 2.0f,
                                                                   CGRectGetMaxY(self.maxWin.frame) + TNItemSpacing,
                                                                   screenWidth - TNItemSpacing * 4.0f,
                                                                   stakeElementHeight
                                                                   )];
    [self.favouriteTeam loadWithTitle:@"Любимая команда:" target:nil action:nil];
    [self.view addSubview:self.favouriteTeam];
    
    self.viewTextFieldsBackground.frame = CGRectSetHeight(
                                                          self.viewTextFieldsBackground.frame,
                                                          CGRectGetMaxY(self.favouriteTeam.frame)
                                                         );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
