//
//  SubscriptionsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 27.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "SubscriptionsViewController.h"
#import "UIViewController+Puntr.h"
#import "UserModel.h"

@interface SubscriptionsViewController ()

@property (nonatomic, strong, readonly) UserModel *user;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation SubscriptionsViewController

- (id)initWithUser:(UserModel *)user
{
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect frame = self.frame;
    
    self.title = @"Подписки";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeSubscriptions modifierObjects:@[self.user]];
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
