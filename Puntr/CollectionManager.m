//
//  CollectionManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "LeadCell.h"

static const CGFloat TNScreenWidth = 320.0f;

static NSString * const TNLeadCellReuseIdentifier = @"LeadCellReuseIdentifier";

@interface CollectionManager ()

@property (nonatomic) CollectionType collectionType;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionData;

@end

@implementation CollectionManager

#pragma mark - Convenience

+ (CollectionManager *)managerWithType:(CollectionType)collectionType
{
    return [[CollectionManager alloc] initWithType:collectionType];
}

#pragma mark - Initialization

- (id)initWithType:(CollectionType)collectionType
{
    self = [super init];
    if (self)
    {
        _collectionType = collectionType;
        [self prepareCollectionView];
    }
    return self;
}

- (void)prepareCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f);
    layout.minimumLineSpacing = 12.0f;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[LeadCell class] forCellWithReuseIdentifier:TNLeadCellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Configured CollectionView

- (UICollectionView *)collectionView
{
    return self.collectionView;
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TNLeadCellReuseIdentifier forIndexPath:indexPath];
    [cell loadWithModel:self.collectionData[indexPath.row]];
    return cell;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeZero;
}

@end
