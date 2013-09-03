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
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeNews modifierObject:nil];
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
