//
//  AwardsCollectionViewController.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardsCollectionViewController.h"
#import "AwardModel.h"
#import "UserModel.h"

#import "AwardCell.h"
#import "AwardViewController.h"

#import "CollectionManager.h"

#import "UIViewController+Puntr.h"

#import "MZFormSheetController.h"
#import "PushContentViewController.h"

@interface AwardsCollectionViewController ()

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation AwardsCollectionViewController

- (id)initWithUser:(UserModel *)user
{
    if (self = [super init])
    {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[MZFormSheetController appearance] setCornerRadius:20.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetController appearance] setShouldDismissOnBackgroundViewTap:YES];

   	CGRect frame = self.frame;
    
    self.title = @"Награды";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeAwards modifierObjects:@[self.user]];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = frame;
    self.collectionManager.collectionManagerDelegate = self;
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionManager reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionViewDidSelectCellWithModel:(id)model {
//    [self.navigationController pushViewController:[[AwardViewController alloc] initWithAward:(AwardModel *)model] animated:YES];
    AwardViewController *vc = [[AwardViewController alloc] initWithAward:(AwardModel *)model];
    // present form sheet with view controller
    [self presentFormSheetWithViewController:vc
                                    animated:YES
                           completionHandler:^(MZFormSheetController *formSheetController) {
    }];

}

@end
