//
//  AwardsCollectionViewController.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardsCollectionViewController.h"
#import "AwardModel.h"
#import "AwardCell.h"
#import "AwardViewController.h"

#import "CollectionManager.h"

@interface AwardsCollectionViewController ()

@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation AwardsCollectionViewController

- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 16.0f;
    layout.minimumInteritemSpacing = 16.0f;
    if (self = [super initWithCollectionViewLayout:layout])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.title = @"Награды";
    
    [self.collectionView registerClass:[AwardCell class] forCellWithReuseIdentifier:@"AwardCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeAwards modifierObject:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = CGRectMake(
                                      0.0f,
                                      12.0f,
                                      CGRectGetWidth(viewControllerFrame),
                                      CGRectGetHeight(viewControllerFrame)
                                      );
    [self.view addSubview:collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.collectionManager reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(296.0f, 296.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AwardCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AwardCell" forIndexPath:indexPath];
    cell.frame = cell.bounds;
//    [cell loadWithAward:award];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[AwardViewController alloc] init] animated:YES];
}

@end
