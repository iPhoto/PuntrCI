//
//  SubscribersViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 09.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "SubscribersViewController.h"
#import "UIViewController+Puntr.h"
#import "UserModel.h"

@interface SubscribersViewController ()

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation SubscribersViewController

+ (SubscribersViewController *)subscribersForUser:(UserModel *)user
{
    return [[self alloc] initForUser:user];
}

- (id)initForUser:(UserModel *)user
{
    self = [super init];
    if (self)
    {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect frame = self.frame;
    
    self.title = NSLocalizedString(@"Subscribers title", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeSubscribers modifierObjects:@[self.user]];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = frame;
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionManager reloadData];
}

@end
