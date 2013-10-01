//
//  TournamentViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "TournamentModel.h"
#import "TournamentViewController.h"
#import "UIViewController+Puntr.h"

@interface TournamentViewController ()

@property (nonatomic, strong) TournamentModel *tournament;
@property (nonatomic, strong, readonly) SearchModel *searchParent;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation TournamentViewController

+ (TournamentViewController *)controllerForTournament:(TournamentModel *)tournament search:(SearchModel *)search
{
    return [[self alloc] initWithTournament:tournament search:search];
}

- (id)initWithTournament:(TournamentModel *)tournament search:(SearchModel *)search
{
    self = [super init];
    if (self)
    {
        _searchParent = search;
        _tournament = tournament;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = self.tournament.title;
    
    [self addBalanceButton];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeTournament modifierObjects:self.searchParent ? @[self.tournament, self.searchParent] : @[self.tournament]];
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

- (SearchModel *)search
{
    return self.collectionManager.search;
}

@end
