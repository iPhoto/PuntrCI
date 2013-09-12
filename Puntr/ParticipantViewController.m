//
//  ParticipantViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 7/26/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "ParticipantViewController.h"
#import "ParticipantModel.h"
#import "UIViewController+Puntr.h"

@interface ParticipantViewController ()

@property (nonatomic, strong) ParticipantModel *participant;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation ParticipantViewController

+ (ParticipantViewController *)controllerWithParticipant:(ParticipantModel *)participant
{
    return [[self alloc] initWithParticipant:participant];
}

- (id)initWithParticipant:(ParticipantModel *)participant
{
    self = [super init];
    if (self)
    {
        self.participant = participant;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Участник";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeParticipant modifierObjects:@[self.participant]];
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
