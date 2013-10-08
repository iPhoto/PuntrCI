//
//  NewsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "NewsViewController.h"
#import "NoDataManager.h"
#import "UIViewController+Puntr.h"

static const CGFloat TNItemSpacing = 12.0f;

@interface NewsViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;
@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;
@property (nonatomic, strong) NoDataManager *noDataManager;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"News", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );

    CollectionType collectionType = CollectionTypeNews;
    self.collectionManager = [CollectionManager managerWithType:collectionType modifierObjects:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = viewControllerFrame;
    [self.view addSubview:collectionView];
    
    self.noDataManager = [NoDataManager managerWithType:collectionType];
    self.noDataManager.view = self.view;
    self.collectionManager.collectionManagerDelegate = self.noDataManager;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addBalanceButton];
    [self updateBalance];
    [self.collectionManager reloadData];
}

@end
