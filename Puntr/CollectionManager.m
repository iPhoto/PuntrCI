//
//  CollectionManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "DefaultsManager.h"
#import "LeadCell.h"
#import "Models.h"
#import "ObjectManager.h"
#import "PagingModel.h"

static const CGFloat TNScreenWidth = 320.0f;
static const NSUInteger TNCatalogueLeadLimit = 3;

static NSString * const TNLeadCellReuseIdentifier = @"LeadCellReuseIdentifier";

@interface CollectionManager ()

@property (nonatomic) CollectionType collectionType;
@property (nonatomic, strong) NSArray *modifierObjects;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) PagingModel *paging;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL loading;

@property (nonatomic) NSUInteger groupsCount;
@property (nonatomic) NSUInteger groupsLoaded;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSMutableArray *groupsData;

@property (nonatomic) NSUInteger stationaryObjectsCount;

@end

@implementation CollectionManager

#pragma mark - Convenience

+ (CollectionManager *)managerWithType:(CollectionType)collectionType modifierObjects:(NSArray *)objects
{
    return [[CollectionManager alloc] initWithType:collectionType modifierObjects:(NSArray *)objects];
}

#pragma mark - Initialization

- (id)initWithType:(CollectionType)collectionType modifierObjects:(NSArray *)objects
{
    self = [super init];
    if (self)
    {
        _groupsData = [NSMutableArray array];
        _collectionType = collectionType;
        _modifierObjects = objects;
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

- (void)switchToType:(CollectionType)collectionType
{
    if (self.collectionType != collectionType)
    {
        self.collectionType = collectionType;
        [self reloadData];
    }
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
            case CollectionTypeActivities || CollectionTypeActivitiesSelf:
                [self loadActivities];
                break;
                
            case CollectionTypeAwards:
                [self loadAwards];
                break;
            
            case CollectionTypeBets:
                [self loadBets];
                break;
                
            case CollectionTypeCatalogueEvents:
                [self loadGroups];
                break;
                
            case CollectionTypeCatalogueTournaments:
                [self loadGroups];
                break;
            
            case CollectionTypeEventComments:
                [self loadEventComments];
                break;
                
            case CollectionTypeEvents:
                [self loadEvents];
                break;
                
            case CollectionTypeEventStakes:
                [self loadEventStakes];
                break;
                
            case CollectionTypeMyStakes:
                [self loadMyStakes];
                break;
                
            case CollectionTypeNews:
                [self loadNews];
                break;
                
            case CollectionTypeParticipant:
                [self loadParticipant];
                break;
                
            case CollectionTypePrivacySettings:
                [self loadPrivacySettings];
                break;
                
            case CollectionTypePushSettinds:
                [self loadPushSettings];
                break;
                
            case CollectionTypeSocialsSettings:
                [self loadSocialsSettings];
                break;
                
            case CollectionTypeSubscribers:
                [self loadSubscribers];
                break;
                
            case CollectionTypeSubscriptions:
                [self loadSubscriptions];
                break;
                
            case CollectionTypeTournament:
                [self loadGroups];
                break;
                
            case CollectionTypeTournamentEvents:
                [self loadTournamentEvents];
                break;
                
            case CollectionTypeTournaments:
                [self loadTournaments];
                break;
                
            default:
                break;
        }
    }
}

- (void)loadActivities
{
    UserModel *user = [self objectInArray:self.modifierObjects ofClass:[UserModel class]];
    [[ObjectManager sharedManager] activitiesForUser:user
                                              paging:self.paging
                                             success:^(NSArray *activities)
                                             {
                                                 if (self.paging.isFirstPage)
                                                 {
                                                     UserModel *user = [self objectInArray:self.modifierObjects ofClass:[UserModel class]];
                                                     NSArray *stationaryObjects = @[user];
                                                     self.stationaryObjectsCount = stationaryObjects.count;
                                                     [self combineWithStationaryObjects:stationaryObjects withNewObjects:activities];
                                                 }
                                                 else
                                                 {
                                                     [self combineWithData:activities];
                                                 }
                                             }
                                             failure:^
                                             {
                                                 [self finishLoading];
                                             }
    ];
}

- (void)loadAwards
{
    UserModel *user = [self objectInArray:self.modifierObjects ofClass:[UserModel class]];
    [[ObjectManager sharedManager] awardsForUser:user
                                          paging:self.paging
                                         success:^(NSArray *awards)
                                         {
                                            [self combineWithData:awards];
                                         }
                                         failure:nil
     ];
}

- (void)loadBets
{
    SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeMyStakes
                                                     firstTitle:@"Ставки"
                                                        firstOn:self.collectionType == CollectionTypeMyStakes ? YES : NO
                                                     secondType:CollectionTypeBets
                                                    secondTitle:@"Пари"
                                                       secondOn:self.collectionType == CollectionTypeBets ? YES : NO];
    NSArray *stationaryObjects = @[switchModel];
    self.stationaryObjectsCount = stationaryObjects.count;
    [self combineWithStationaryObjects:stationaryObjects withNewObjects:@[]];
}

- (void)loadCatalogueEvents
{
    // Groups with Events
    NSMutableArray *groupsData = [NSMutableArray array];
    for (NSArray *data in self.groupsData)
    {
        GroupModel *group = self.groups[[self.groupsData indexOfObjectIdenticalTo:data]];
        [groupsData addObject:group];
        [groupsData addObjectsFromArray:data];
    }
    
    // Tournaments
    GroupModel *groupTournaments = [GroupModel group];
    groupTournaments.slug = KeyTournaments;
    groupTournaments.title = @"Турниры";
    groupTournaments.imageHardcode = [UIImage imageNamed:@"sectionTournaments"];
    [groupsData addObject:groupTournaments];
    
    self.collectionData = [groupsData copy];

    [self.collectionView reloadData];
    
    [self finishLoading];
}

- (void)loadCatalogueTournaments
{
    // Groups with Tournaments
    NSMutableArray *groupsData = [self groupsWithObjects];
    self.collectionData = [groupsData copy];
    
    [self.collectionView reloadData];
    
    [self finishLoading];
}

- (void)loadEventComments
{
    EventModel *event = [self objectInArray:self.modifierObjects ofClass:[EventModel class]];
    [[ObjectManager sharedManager] commentsForEvent:event
                                             paging:self.paging
                                            success:^(NSArray *comments)
                                            {
                                                if (self.paging.isFirstPage)
                                                {
                                                    SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeEventComments
                                                                                                     firstTitle:@"Комментарии"
                                                                                                        firstOn:self.collectionType == CollectionTypeEventComments ? YES : NO
                                                                                                     secondType:CollectionTypeEventStakes
                                                                                                    secondTitle:@"Ставки"
                                                                                                       secondOn:self.collectionType == CollectionTypeEventStakes ? YES : NO];
                                                    NSArray *stationaryObjects = @[switchModel];
                                                    self.stationaryObjectsCount = stationaryObjects.count;
                                                    [self combineWithStationaryObjects:stationaryObjects withNewObjects:comments];
                                                }
                                                else
                                                {
                                                    [self combineWithData:comments];
                                                }
                                            }
                                            failure:^
                                            {
                                                [self finishLoading];
                                            }
    ];
}

- (void)loadEvents
{
    GroupModel *group = [self objectInArray:self.modifierObjects ofClass:[GroupModel class]];
    FilterModel *filter = [FilterModel filter];
    filter.group = group;
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    if (![category.tag isEqualToNumber:@0])
    {
        filter.categories = @[category];
        [self loadEventsWithFilter:filter];
    }
    else
    {
        [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
            {
                filter.categories = includedCategories;
                [self loadEventsWithFilter:filter];
            }
        ];
    }
}

- (void)loadEventStakes
{
    EventModel *event = [self objectInArray:self.modifierObjects ofClass:[EventModel class]];
    [[ObjectManager sharedManager] stakesForEvent:event
                                           paging:self.paging
                                          success:^(NSArray *stakes)
                                          {
                                              if (self.paging.isFirstPage)
                                              {
                                                  SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeEventComments
                                                                                                   firstTitle:@"Комментарии"
                                                                                                      firstOn:self.collectionType == CollectionTypeEventComments ? YES : NO
                                                                                                   secondType:CollectionTypeEventStakes
                                                                                                  secondTitle:@"Ставки"
                                                                                                     secondOn:self.collectionType == CollectionTypeEventStakes ? YES : NO];
                                                  NSArray *stationaryObjects = @[switchModel];
                                                  self.stationaryObjectsCount = stationaryObjects.count;
                                                  [self combineWithStationaryObjects:stationaryObjects withNewObjects:stakes];
                                              }
                                              else
                                              {
                                                  [self combineWithData:stakes];
                                              }
                                          }
                                          failure:^
                                          {
                                              [self finishLoading];
                                          }
    ];
}

- (void)loadEventsWithFilter:(FilterModel *)filter
{
    [self loadEventsWithGroup:nil groups:nil paging:nil filter:filter];
}

- (void)loadEventsWithGroup:(GroupModel *)group groups:(NSArray *)groups paging:(PagingModel *)paging filter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] eventsWithPaging:paging ? paging : self.paging
                                             filter:filter
                                            success:^(NSArray *events)
                                            {
                                                if (groups)
                                                {
                                                    self.groupsLoaded++;
                                                    [self.groupsData replaceObjectAtIndex:[groups indexOfObjectIdenticalTo:group] withObject:events];
                                                    if (self.groupsLoaded == self.groupsCount)
                                                    {
                                                        [self loadCatalogueEvents];
                                                    }
                                                }
                                                else
                                                {
                                                    [self combineWithData:events];
                                                }
                                            }
                                            failure:^
                                            {
                                                [self finishLoading];
                                            }
    ];
}

- (void)loadGroups
{
    self.groupsLoaded = 0;
    self.groupsCount = 0;
    self.groups = nil;
    [self.groupsData removeAllObjects];
    
    [[ObjectManager sharedManager] groupsWithSuccess:^(NSArray *groups)
        {
            self.groupsCount = groups.count;
            self.groups = groups;
            [self.groupsData addObjectsFromArray:groups];
            
            PagingModel *paging = [PagingModel paging];
            [paging setDefaultLimit:@(TNCatalogueLeadLimit)];
            [paging firstPage];
            
            for (GroupModel *group in groups)
            {
                FilterModel *filter = [FilterModel filter];
                filter.group = group;
                CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
                if (![category.tag isEqualToNumber:@0])
                {
                    filter.categories = @[category];
                    if (self.collectionType == CollectionTypeCatalogueTournaments)
                    {
                        [self loadTournamentsWithGroup:group groups:groups paging:paging filter:filter];
                    }
                    else if (self.collectionType == CollectionTypeTournament)
                    {
                        [self loadTournamentEventsWithGroup:group groups:groups paging:paging filter:filter];
                    }
                    else
                    {
                        [self loadEventsWithGroup:group groups:groups paging:paging filter:filter];
                    }
                }
                else
                {
                    [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
                        {
                            filter.categories = includedCategories;
                            if (self.collectionType == CollectionTypeCatalogueTournaments)
                            {
                                [self loadTournamentsWithGroup:group groups:groups paging:paging filter:filter];
                            }
                            else if (self.collectionType == CollectionTypeTournament)
                            {
                                [self loadTournamentEventsWithGroup:group groups:groups paging:paging filter:filter];
                            }
                            else
                            {
                                [self loadEventsWithGroup:group groups:groups paging:paging filter:filter];
                            }
                        }
                    ];
                }
                    
            }
        }
        failure:^
        {
            [self finishLoading];
        }
    ];
}

- (void)loadMyStakes
{
    [[ObjectManager sharedManager] myStakesWithPaging:self.paging success:^(NSArray *stakes)
        {
            if (self.paging.isFirstPage)
            {
                SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeMyStakes
                                                                 firstTitle:@"Ставки"
                                                                    firstOn:self.collectionType == CollectionTypeMyStakes ? YES : NO
                                                                 secondType:CollectionTypeBets
                                                                secondTitle:@"Пари"
                                                                   secondOn:self.collectionType == CollectionTypeBets ? YES : NO];
                NSArray *stationaryObjects = @[switchModel];
                self.stationaryObjectsCount = stationaryObjects.count;
                [self combineWithStationaryObjects:stationaryObjects withNewObjects:stakes];
            }
            else
            {
                [self combineWithData:stakes];
            }
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

- (void)loadParticipant
{
    ParticipantModel *participant = [self objectInArray:self.modifierObjects ofClass:[ParticipantModel class]];
    [[ObjectManager sharedManager] eventsForParticipant:participant
                                                 paging:self.paging
                                                success:^(NSArray *events)
                                                {
                                                    if (self.paging.isFirstPage)
                                                    {
                                                        NSArray *stationaryObjects = @[participant];
                                                        self.stationaryObjectsCount = stationaryObjects.count;
                                                        [self combineWithStationaryObjects:stationaryObjects withNewObjects:events];
                                                    }
                                                    else
                                                    {
                                                        [self combineWithData:events];
                                                    }
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

- (void)loadSocialsSettings
{
    [[ObjectManager sharedManager] userWithTag:[[ObjectManager sharedManager] loginedUser].tag success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         UserModel *profile = (UserModel *)mappingResult.firstObject;
         
         DynamicSelectionModel *fbDynamicModel = [[DynamicSelectionModel alloc] init];
         fbDynamicModel.slug = KeyFacebook;
         fbDynamicModel.status = profile.socials.facebook;
         fbDynamicModel.title = @"Facebook";
         
         DynamicSelectionModel *twDynamicModel = [[DynamicSelectionModel alloc] init];
         twDynamicModel.slug = KeyTwitter;
         twDynamicModel.status = profile.socials.twitter;
         twDynamicModel.title = @"Twitter";
         
         DynamicSelectionModel *vkDynamicModel = [[DynamicSelectionModel alloc] init];
         vkDynamicModel.slug = KeyVKontakte;
         vkDynamicModel.status = profile.socials.vk;
         vkDynamicModel.title = @"VKontakte";
         
         [self combineWithData:@[fbDynamicModel, twDynamicModel, vkDynamicModel]];
     }
                                       failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self finishLoading];
     }
    ];
}

- (void)loadSubscribers
{
    UserModel *user = [self objectInArray:self.modifierObjects ofClass:[UserModel class]];
    [[ObjectManager sharedManager] subscribersForUser:user
                                               paging:self.paging
                                              success:^(NSArray *subscribers)
                                              {
                                                  [self combineWithData:subscribers];
                                              }
                                              failure:^
                                              {
                                                  [self finishLoading];
                                              }
    ];
}

- (void)loadSubscriptions
{
    UserModel *user = [self objectInArray:self.modifierObjects ofClass:[UserModel class]];
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

- (void)loadTournament
{
    // Groups with Events
    NSMutableArray *groupsWithEvents = [self groupsWithObjects];
    TournamentModel *tournament = [self objectInArray:self.modifierObjects ofClass:[TournamentModel class]];
    [groupsWithEvents insertObject:tournament atIndex:0];
    
    self.collectionData = [groupsWithEvents copy];
    
    [self.collectionView reloadData];
    
    [self finishLoading];
}

- (void)loadTournamentEvents
{
    GroupModel *group = [self objectInArray:self.modifierObjects ofClass:[GroupModel class]];
    FilterModel *filter = [FilterModel filter];
    filter.group = group;
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    if (![category.tag isEqualToNumber:@0])
    {
        filter.categories = @[category];
        [self loadTournamentEventsWithFilter:filter];
    }
    else
    {
        [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
            {
                filter.categories = includedCategories;
                [self loadTournamentEventsWithFilter:filter];
            }
        ];
    }
}

- (void)loadTournamentEventsWithFilter:(FilterModel *)filter
{
    [self loadTournamentEventsWithGroup:nil groups:nil paging:nil filter:filter];
}
         
- (void)loadTournamentEventsWithGroup:(GroupModel *)group groups:(NSArray *)groups paging:(PagingModel *)paging filter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] eventsForTournament:[self objectInArray:self.modifierObjects ofClass:[TournamentModel class]]
                                                paging:paging ? paging : self.paging
                                                filter:filter
                                               success:^(NSArray *events)
                                               {
                                                   if (groups)
                                                   {
                                                       self.groupsLoaded++;
                                                       [self.groupsData replaceObjectAtIndex:[groups indexOfObjectIdenticalTo:group] withObject:events];
                                                       if (self.groupsLoaded == self.groupsCount)
                                                       {
                                                           [self loadTournament];
                                                       }
                                                   }
                                                   else
                                                   {
                                                       [self combineWithData:events];
                                                   }
                                               }
                                               failure:^
                                               {
                                                   [self finishLoading];
                                               }
    ];
}

- (void)loadTournaments
{
    GroupModel *group = [self objectInArray:self.modifierObjects ofClass:[GroupModel class]];
    FilterModel *filter = [FilterModel filter];
    filter.group = group;
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    if (![category.tag isEqualToNumber:@0])
    {
        filter.categories = @[category];
        [self loadTournamentsWithFilter:filter];
    }
    else
    {
        [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
         {
             filter.categories = includedCategories;
             [self loadTournamentsWithFilter:filter];
         }
         ];
    }
}

- (void)loadTournamentsWithFilter:(FilterModel *)filter
{
    [self loadTournamentsWithGroup:nil groups:nil paging:nil filter:filter];
}

- (void)loadTournamentsWithGroup:(GroupModel *)group groups:(NSArray *)groups paging:(PagingModel *)paging filter:(FilterModel *)filter
{   
    [[ObjectManager sharedManager] tournamentsWithPaging:paging ? paging : self.paging
                                                  filter:filter
                                                 success:^(NSArray *tournaments)
                                                 {
                                                     if (groups)
                                                     {
                                                         self.groupsLoaded++;
                                                         [self.groupsData replaceObjectAtIndex:[groups indexOfObjectIdenticalTo:group] withObject:tournaments];
                                                         if (self.groupsLoaded == self.groupsCount)
                                                         {
                                                             [self loadCatalogueTournaments];
                                                         }
                                                     }
                                                     else
                                                     {
                                                         [self combineWithData:tournaments];
                                                     }
                                                 }
                                                 failure:^
                                                 {
                                                     [self finishLoading];
                                                 }
    ];
}

- (void)combineWithData:(NSArray *)newData
{
    if (newData.count)
    {
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
    else
    {
        NSMutableArray *oldData = [NSMutableArray arrayWithArray:self.collectionData];
        if ([oldData.lastObject isMemberOfClass:[LoadModel class]])
        {
            [oldData removeLastObject];
        }
        self.collectionData = [oldData copy];
        
        [self.collectionView reloadData];
    }
    
    if ([self.collectionManagerDelegate respondsToSelector:@selector(haveItems:withCollectionType:)])
    {
        if (self.collectionData.count - self.stationaryObjectsCount <= 0)
        {
            [self.collectionManagerDelegate haveItems:NO withCollectionType:self.collectionType];
        }
        else
        {
            [self.collectionManagerDelegate haveItems:YES withCollectionType:self.collectionType];
        }
    }
    
    [self finishLoading];
}

- (void)combineWithStationaryObjects:(NSArray *)stationaryObjects withNewObjects:(NSArray *)newObjects
{
    NSMutableArray *combined = [NSMutableArray arrayWithCapacity:newObjects.count + stationaryObjects.count];
    [combined addObjectsFromArray:stationaryObjects];
    [combined addObjectsFromArray:newObjects];
    
    [self combineWithData:[combined copy]];
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
    id model = self.collectionData[indexPath.row];
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
    id model = self.collectionData[indexPath.row];
    if ([self.collectionManagerDelegate respondsToSelector:@selector(collectionViewDidSelectCellWithModel:)])
    {
        [self.collectionManagerDelegate collectionViewDidSelectCellWithModel:model];
    }
}

#pragma mark - Utility

- (NSMutableArray *)groupsWithObjects
{
    NSMutableArray *groupsWithEvents = [NSMutableArray array];
    for (NSArray *data in self.groupsData)
    {
        GroupModel *group = self.groups[[self.groupsData indexOfObjectIdenticalTo:data]];
        [groupsWithEvents addObject:group];
        [groupsWithEvents addObjectsFromArray:data];
    }
    return groupsWithEvents;
}

- (id)objectInArray:(NSArray *)array ofClass:(Class)class
{
    for (id object in array)
    {
        if ([object isMemberOfClass:class])
        {
            return object;
        }
    }
    return nil;
}

@end
