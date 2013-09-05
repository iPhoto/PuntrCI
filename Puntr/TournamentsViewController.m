//
//  TournamentsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "GroupModel.h"
#import "TournamentsViewController.h"
#import "UIViewController+Puntr.h"

@interface TournamentsViewController ()

@property (nonatomic, strong, readonly) GroupModel *group;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation TournamentsViewController

+ (TournamentsViewController *)tournamentsForGroup:(GroupModel *)group
{
    return [[self alloc] initWithGroup:group];
}

- (id)initWithGroup:(GroupModel *)group
{
    self = [super init];
    if (self)
    {
        _group = group;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = self.group.title;
    
    [self addBalanceButton];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeTournaments modifierObject:self.group];
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
