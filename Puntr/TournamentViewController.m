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

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation TournamentViewController

+ (TournamentViewController *)controllerForTournament:(TournamentModel *)tournament
{
    return [[self alloc] initWithTournament:tournament];
}

- (id)initWithTournament:(TournamentModel *)tournament
{
    self = [super init];
    if (self)
    {
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
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeTournament modifierObjects:@[self.tournament]];
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
