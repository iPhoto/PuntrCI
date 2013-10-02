//
//  ParticipantsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 01.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "ParticipantsViewController.h"
#import "UIViewController+Puntr.h"

@interface ParticipantsViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;

@property (nonatomic, strong, readonly) SearchModel *searchParent;

@end

@implementation ParticipantsViewController

+ (ParticipantsViewController *)participantsWithSearch:(SearchModel *)search
{
    return [[self alloc] initWithSearch:search];
}

- (id)initWithSearch:(SearchModel *)search
{
    self = [super init];
    if (self)
    {
        _searchParent = search;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = NSLocalizedString(@"Participants", nil);
    
    [self addBalanceButton];
    
    CollectionType type = CollectionTypeParticipants;
    NSArray *modifierObjects = self.searchParent ? @[self.searchParent] : nil;
    
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

- (SearchModel *)search
{
    return self.collectionManager.search;
}

@end
