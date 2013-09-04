//
//  TournamentsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 04.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoriesManager.h"
#import "CollectionManager.h"
#import "TournamentsViewController.h"
#import "UIViewController+Puntr.h"

static const CGFloat TNWidthScreen = 320.0f;
static const CGFloat TNHeightCategories = 35.0f;

@interface TournamentsViewController ()

@property (nonatomic, strong) CategoriesManager *categoriesManager;
@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation TournamentsViewController

+ (TournamentsViewController *)tournaments
{
    return [[self alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = @"Турниры";
    
    [self addBalanceButton];
    
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
    
    // Groups & Tournaments
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeCatalogueTournaments modifierObject:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = CGRectMake(
                                         0.0f,
                                         TNHeightCategories,
                                         TNWidthScreen,
                                         CGRectGetHeight(self.frame) - TNHeightCategories
                                     );
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
    [self.categoriesManager reloadData];
}

@end
