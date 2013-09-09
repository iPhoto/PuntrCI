//
//  CatalogueEventsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CatalogueEventsViewController.h"
#import "CategoriesManager.h"
#import "CollectionManager.h"
#import "UIViewController+Puntr.h"

static const CGFloat TNWidthScreen = 320.0f;
static const CGFloat TNHeightCategories = 35.0f;

@interface CatalogueEventsViewController ()

@property (nonatomic, strong) CategoriesManager *categoriesManager;
@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation CatalogueEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = @"Каталог";
    
    [self addBalanceButton];
    [self addFilterButton];
    
    // Categories
    self.categoriesManager = [CategoriesManager manager];
    UICollectionView *collectionViewCategories = self.categoriesManager.collectionView;
    collectionViewCategories.frame = CGRectMake(
                                                   0.0f,
                                                   0.0f,
                                                   TNWidthScreen,
                                                   TNHeightCategories
                                               );
    [self.view addSubview:collectionViewCategories];
    
    // Groups & Events
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeCatalogueEvents modifierObjects:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = CGRectMake(
                                         0.0f,
                                         TNHeightCategories,
                                         TNWidthScreen,
                                         CGRectGetHeight(self.frame) - TNHeightCategories
                                     );
    [self.view addSubview:collectionView];
    CollectionManager *collectionManager = self.collectionManager;
    self.categoriesManager.callback = ^(){
        [collectionManager reloadData];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
    [self.categoriesManager reloadData];
}

@end
