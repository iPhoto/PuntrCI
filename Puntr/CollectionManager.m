//
//  CollectionManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "EventModel.h"
#import "LeadCell.h"
#import "ObjectManager.h"
#import "PagingModel.h"

static const CGFloat TNScreenWidth = 320.0f;

static NSString * const TNLeadCellReuseIdentifier = @"LeadCellReuseIdentifier";

@interface CollectionManager ()

@property (nonatomic) CollectionType collectionType;
@property (nonatomic, strong) NSObject *modifierObject;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) PagingModel *paging;

@end

@implementation CollectionManager

#pragma mark - Convenience

+ (CollectionManager *)managerWithType:(CollectionType)collectionType modifierObject:(NSObject *)object
{
    return [[CollectionManager alloc] initWithType:collectionType modifierObject:(NSObject *)object];
}

#pragma mark - Initialization

- (id)initWithType:(CollectionType)collectionType modifierObject:(NSObject *)object
{
    self = [super init];
    if (self)
    {
        _collectionType = collectionType;
        _modifierObject = object;
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

#pragma mark - Data

- (void)reloadData
{
    self.collectionData = nil;
    switch (self.collectionType)
    {
        case CollectionTypeMyStakes:
            [self loadMyStakes];
            break;
            
        case CollectionTypeEventStakes:
            [self loadStakes];
            break;
            
        default:
            break;
    }
}

- (void)loadMyStakes
{
    [[ObjectManager sharedManager] myStakesWithPaging:self.paging success:^(NSArray *stakes)
        {
            [self combineWithData:stakes];
        }
        failure:nil
    ];
}

- (void)loadStakes
{
    EventModel *event = (EventModel *)self.modifierObject;
    [[ObjectManager sharedManager] stakesForEvent:event
                                           paging:self.paging
                                          success:^(NSArray *stakes)
                                          {
                                              [self combineWithData:stakes];
                                          }
                                          failure:nil];
}

- (void)combineWithData:(NSArray *)newData
{
    NSMutableArray *combinedData = [NSMutableArray arrayWithCapacity:self.collectionData.count + newData.count];
    [combinedData addObjectsFromArray:self.collectionData];
    [combinedData addObjectsFromArray:newData];
    self.collectionData = [combinedData copy];
    
    [self.collectionView reloadData];
}


#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
    return [LeadCell sizeForModel:self.collectionData[indexPath.row]];
}

@end
