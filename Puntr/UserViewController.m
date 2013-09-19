//
//  UserViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "NoDataManager.h"
#import "ObjectManager.h"
#import "SettingsViewController.h"
#import "UIViewController+Puntr.h"
#import "UserModel.h"
#import "UserViewController.h"

@interface UserViewController ()

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) CollectionManager *collectionManager;

@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;

@property (nonatomic, strong) NoDataManager *noDataManager;

@end

@implementation UserViewController

- (id)initWithUser:(UserModel *)user
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
    if (!self.user)
    {
        self.title = @"Профиль";
        [self addSettingsButton];
        self.user = [[ObjectManager sharedManager] loginedUser];
        self.noDataManager = [[NoDataManager alloc] initWithNoDataOfType:NoDataTypeProfile];
    }
    else
    {
        self.title = @"Игрок";
        self.noDataManager = [[NoDataManager alloc] initWithNoDataOfType:NoDataTypeOtherUser];
    }
    self.noDataManager.view = self.view;
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeActivities modifierObjects:@[self.user]];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = self.frame;
    [self.view addSubview:collectionView];
    
    self.collectionManager.collectionManagerDelegate = self.noDataManager;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

- (void)settingsButtonTouched
{
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
