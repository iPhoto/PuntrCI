//
//  NewsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "NewsViewController.h"
#import "UIViewController+Puntr.h"

static const CGFloat TNItemSpacing = 12.0f;

@interface NewsViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Новости";
    [self addBalanceButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeNews modifierObject:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = viewControllerFrame;
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

@end
