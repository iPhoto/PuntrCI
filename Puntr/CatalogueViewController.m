//
//  CatalogueViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CatalogueViewController.h"
#import "CollectionManager.h"
#import "UIViewController+Puntr.h"

@interface CatalogueViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation CatalogueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = @"Каталог";
    
    [self addBalanceButton];
    [self addFilterButton];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeCatalogueEvents modifierObject:nil];
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

- (void)addFilterButton
{
    UIButton *buttonFilter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonFilter setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonFilter setImage:[UIImage imageNamed:@"IconFilter"] forState:UIControlStateNormal];
    [buttonFilter setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    [buttonFilter addTarget:self action:@selector(touchedButtonFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:buttonFilter];
    self.navigationItem.leftBarButtonItem = settingsItem;
}

@end
