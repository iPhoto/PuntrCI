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
    
    self.title = @"Мои ставки";
    [self addBalanceButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeMyStakes modifierObjects:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = self.frame;
    [self.view addSubview:collectionView];
    
    self.noDataManager = [[NoDataManager alloc] initWithNoDataOfType:NoDataTypeStakes];
    self.noDataManager.view = self.view;
    self.collectionManager.collectionManagerDelegate = self.noDataManager;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

@end
