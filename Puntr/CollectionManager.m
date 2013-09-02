//
//  CollectionManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
//#import "EventModel.h"
//#import "LeadCell.h"

#import "Models.h"

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

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL loading;

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
        _paging = [[PagingModel alloc] init];
        [_paging firstPage];
        _collectionType = collectionType;
        _modifierObject = object;
        [self prepareCollectionView];
    }
    return self;
}

- (void)prepareCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self.collectionType == CollectionTypeAwards)
    {
        layout.sectionInset = UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
    }
    else
    {
        layout.sectionInset = UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f);
    }
    layout.minimumLineSpacing = 12.0f;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[LeadCell class] forCellWithReuseIdentifier:TNLeadCellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    _refreshControl.tintColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [_collectionView addSubview:_refreshControl];
}

#pragma mark - Data

- (void)reloadData
{
    self.collectionData = nil;
    self.paging = nil;
    [self loadData];
}

- (void)loadData
{
    if (!self.loading)
    {
        self.loading = YES;
        
        if (!self.paging)
        {
            self.paging = [PagingModel paging];
            [self.paging firstPage];
        }
        else
        {
            [self.paging nextPage];
        }
        
        switch (self.collectionType)
        {
            case CollectionTypeActivities:
                [self loadActivities];
                break;
                
            case CollectionTypeAwards:
                [self loadAwards];
                break;
                
            case CollectionTypeEventStakes:
                [self loadStakes];
                break;
                
            case CollectionTypeMyStakes:
                [self loadMyStakes];
                break;
                
            case CollectionTypeNews:
                [self loadNews];
                break;
                
            case CollectionTypeSubscriptions:
                [self loadSubscriptions];
                break;
                
            case CollectionTypePrivacySettings:
                [self loadPrivacySettings];
                break;
                
            case CollectionTypePushSettinds:
                [self loadPushSettings];
                break;
                
            default:
                break;
        }
    }
}

- (void)loadMyStakes
{
    [[ObjectManager sharedManager] myStakesWithPaging:self.paging success:^(NSArray *stakes)
        {
            [self combineWithData:stakes];
        }
        failure:^
        {
            [self finishLoading];
        }
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
                                          failure:^
                                          {
                                              [self finishLoading];
                                          }
    ];
}

- (void)loadActivities
{
    UserModel *user = (UserModel *)self.modifierObject;
    [[ObjectManager sharedManager] activitiesForUser:user
                                              paging:self.paging
                                             success:^(NSArray *activities)
                                             {
                                                 [self combineWithData:activities];
                                             }
                                             failure:^
                                             {
                                                 [self finishLoading];
                                             }
    ];
}

- (void)loadNews
{
    [[ObjectManager sharedManager] newsWithPaging:self.paging
                                          success:^(NSArray *news)
                                          {
                                              [self combineWithData:news];
                                          }
                                          failure:^
                                          {
                                              [self finishLoading];
                                          }
    ];
}

- (void)loadPrivacySettings
{
    [[ObjectManager sharedManager] privacyWithSuccess:^(NSArray *privacy)
                                              {
                                                  [self combineWithData:privacy];
                                              }
                                              failure:^
                                              {
                                                  [self finishLoading];
                                              }
    ];
}

- (void)loadPushSettings
{
    [[ObjectManager sharedManager] pushWithSuccess:^(NSArray *push)
                                           {
                                               [self combineWithData:push];
                                           }
                                           failure:^
                                           {
                                               [self finishLoading];
                                           }
    ];
}

- (void)loadSubscriptions
{
    UserModel *user = (UserModel *)self.modifierObject;
    [[ObjectManager sharedManager] subscriptionsForUser:user
                                                 paging:self.paging
                                                success:^(NSArray *subscriptions)
                                                {
                                                    [self combineWithData:subscriptions];
                                                }
                                                failure:^
                                                {
                                                    [self finishLoading];
                                                }
    ];
}

- (void)loadAwards
{
    
    AwardModel *award = [[AwardModel alloc] init];
    award.title = @"award1";
    award.description = @"blah blah balah";
    award.image = [NSURL URLWithString:@"http://img-fotki.yandex.ru/get/9113/223557196.d/0_beeb9_4cba89a4_orig"];

    AwardModel *award1 = [[AwardModel alloc] init];
    award1.title = @"award2";
    award1.description = @"award2 description";
    award1.image = [NSURL URLWithString:@"http://i130.photobucket.com/albums/p273/runata/433043004400_zpsc277ec3d.jpg"];

    AwardModel *award2 = [[AwardModel alloc] init];
    award2.title = @"award3";
    award2.description = @"award3 description";
    award2.image = [NSURL URLWithString:@"http://img2.joyreactor.cc/pics/post/1-сентября-песочница-855392.jpeg"];
    
    NSArray *awards = [NSArray arrayWithObjects:award, award1, award2, nil];
    [self combineWithData:awards];
    
//    UserModel *user = (UserModel *)self.modifierObject;
//    [[ObjectManager sharedManager] awardsForUser:user
//                                          paging:self.paging
//                                         success:^(NSArray *awards)
//                                         {
//                                            [self combineWithData:awards];
//                                         }
//                                         failure:nil
//     ];
}

- (void)combineWithData:(NSArray *)newData
{
    if (newData.count) {
        BOOL finalData = (NSInteger)newData.count < self.paging.limit.integerValue;
        NSMutableArray *combinedData = [NSMutableArray arrayWithCapacity:self.collectionData.count + newData.count];
        NSMutableArray *oldData = [NSMutableArray arrayWithArray:self.collectionData];
        if ([oldData.lastObject isMemberOfClass:[LoadModel class]])
        {
            [oldData removeLastObject];
        }
        [combinedData addObjectsFromArray:oldData];
        [combinedData addObjectsFromArray:newData];
        if (!finalData)
        {
            [combinedData addObject:[[LoadModel alloc] init]];
        }
        self.collectionData = [combinedData copy];
        
        [self.collectionView reloadData];
    }
    [self finishLoading];
}

- (void)finishLoading
{
    self.loading = NO;
    [self.refreshControl endRefreshing];
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
    NSObject *model = self.collectionData[indexPath.row];
    if ([model isMemberOfClass:[LoadModel class]])
    {
        [self loadData];
    }
    [cell loadWithModel:model];
    cell.delegate = self;
    return cell;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [LeadCell sizeForModel:self.collectionData[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *model = self.collectionData[indexPath.row];
    if ([self.collectionManagerDelegate respondsToSelector:@selector(collectionViewDidSelectCellWithModel:)])
    {
        [self.collectionManagerDelegate collectionViewDidSelectCellWithModel:model];
    }
}

@end
