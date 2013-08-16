//
//  MyStakesViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "MyStakesViewController.h"
#import "UIViewController+Puntr.h"
#import "CollectionManager.h"

static const CGFloat TNItemSpacing = 12.0f;

@interface MyStakesViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation MyStakesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Мои ставки";
    [self addBalanceButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Ставки", @"Пари"]];
    self.segmentedControl.frame = CGRectMake(15.0f, TNItemSpacing, 290.0f, 31.0f);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor blackColor];
    [self.view addSubview:self.segmentedControl];
    dispatch_async(dispatch_get_main_queue(), ^
        {
            self.segmentedControl.selectedSegmentIndex = 1;
        }
    );
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeMyStakes];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = CGRectMake(
                                      0.0f,
                                      CGRectGetMaxY(self.segmentedControl.frame) + TNItemSpacing,
                                      CGRectGetWidth(viewControllerFrame),
                                      CGRectGetHeight(viewControllerFrame) - (CGRectGetMaxY(self.segmentedControl.frame) + TNItemSpacing)
                                     );
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

@end
