//
//  MyStakesViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "NoDataManager.h"
#import "MyStakesViewController.h"
#import "UIViewController+Puntr.h"

@interface MyStakesViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;
@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;
@property (nonatomic, strong) NoDataManager *noDataManager;

@end

@implementation MyStakesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"My stakes", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CollectionType collectionType = CollectionTypeMyStakes;
    self.collectionManager = [CollectionManager managerWithType:collectionType modifierObjects:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = self.frame;
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
