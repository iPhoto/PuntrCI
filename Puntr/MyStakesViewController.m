//
//  MyStakesViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "MyStakesViewController.h"
#import "UIViewController+Puntr.h"

@interface MyStakesViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

@end
