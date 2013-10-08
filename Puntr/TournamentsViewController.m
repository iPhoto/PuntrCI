//
//  TournamentsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "GroupModel.h"
#import "SearchModel.h"
#import "TournamentsViewController.h"
#import "UIViewController+Puntr.h"

@interface TournamentsViewController ()

@property (nonatomic, strong, readonly) GroupModel *group;
@property (nonatomic, strong, readonly) SearchModel *searchParent;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation TournamentsViewController

+ (TournamentsViewController *)tournamentsForGroup:(GroupModel *)group search:(SearchModel *)search
{
    return [[self alloc] initWithGroup:group search:search];
}

- (id)initWithGroup:(GroupModel *)group search:(SearchModel *)search
{
    self = [super init];
    if (self)
    {
        _group = group;
        _searchParent = search;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = self.group.title;
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeTournaments modifierObjects:self.searchParent ? @[self.group, self.searchParent] : @[self.group]];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = self.frame;
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addBalanceButton];
    [self updateBalance];
    [self.collectionManager reloadData];
}

- (SearchModel *)search
{
    return self.collectionManager.search;
}

@end
