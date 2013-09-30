//
//  EventsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 04.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "EventsViewController.h"
#import "GroupModel.h"
#import "TournamentModel.h"
#import "UIViewController+Puntr.h"

@interface EventsViewController ()

@property (nonatomic, strong, readonly) GroupModel *group;
@property (nonatomic, strong, readonly) TournamentModel *tournament;
@property (nonatomic, strong, readonly) SearchModel *search;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation EventsViewController

+ (EventsViewController *)eventsForGroup:(GroupModel *)group tournament:(TournamentModel *)tournament search:(SearchModel *)search
{
    return [[self alloc] initWithGroup:group tournament:tournament search:search];
}

- (id)initWithGroup:(GroupModel *)group tournament:(TournamentModel *)tournament search:(SearchModel *)search
{
    self = [super init];
    if (self)
    {
        _group = group;
        _tournament = tournament;
        _search = search;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = self.group.title;
    
    [self addBalanceButton];
    
    CollectionType type = self.tournament ? CollectionTypeTournamentEvents : CollectionTypeEvents;
    NSArray *modifierObjects = self.tournament ? @[self.group, self.tournament] : @[self.group];
    
    if (self.search)
    {
        NSMutableArray *objects = [NSMutableArray arrayWithArray:modifierObjects];
        [objects addObject:self.search];
        modifierObjects = [objects copy];
    }
    
    self.collectionManager = [CollectionManager managerWithType:type modifierObjects:modifierObjects];
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
