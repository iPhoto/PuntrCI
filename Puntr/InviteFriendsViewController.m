//
//  InviteFriendsViewController.m
//  Puntr
//
//  Created by Momus on 03.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "CollectionManager.h"

#import "UIViewController+Puntr.h"

@interface InviteFriendsViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;
@property (nonatomic) SocialNetworkType socialNetworkType;

@end

@implementation InviteFriendsViewController

+ (InviteFriendsViewController *)friendsForSocialNetworkType:(SocialNetworkType)socialType
{
    return [[self alloc] initWithSocialNetworkType:socialType];
}

- (id)initWithSocialNetworkType:(SocialNetworkType)socialType
{
    self = [super init];
    if (self)
    {
        _socialNetworkType = socialType;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = @"Пригласить друзей";
    
    [self addBalanceButton];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeInviteFriends modifierObjects:nil];
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
