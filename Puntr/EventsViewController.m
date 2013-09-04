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
#import "UIViewController+Puntr.h"

@interface EventsViewController ()

@property (nonatomic, strong, readonly) GroupModel *group;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation EventsViewController

+ (EventsViewController *)eventsForGroup:(GroupModel *)group
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
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeEvents modifierObject:self.group];
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
