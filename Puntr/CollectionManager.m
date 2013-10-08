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
@property (nonatomic, strong) NSArray *collectionObjects;
@property (nonatomic, strong) PagingModel *paging;
@property (nonatomic, strong) SearchModel *search;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL loading;

@property (nonatomic) NSUInteger groupsCount;
@property (nonatomic) NSUInteger groupsLoaded;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSMutableArray *groupObjects;
@property (nonatomic, strong) NSArray *catalogueEventsTournaments;
@property (nonatomic, strong) NSArray *catalogueEventsParticipants;
@property (nonatomic, strong) NSArray *catalogueEventsUsers;

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
        _groupObjects = [NSMutableArray array];
        _collectionType = collectionType;
        _modifierObjects = objects;
        _search = [self objectInArray:objects ofClass:[SearchModel class]];
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
    self.collectionObjects = nil;
    self.paging = nil;
    self.catalogueEventsParticipants = nil;
    self.catalogueEventsTournaments = nil;
    self.catalogueEventsUsers = nil;
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
            case CollectionTypeActivities:
            case CollectionTypeActivitiesSelf:
                [self loadActivities];
                break;
                
            case CollectionTypeAwards:
                [self loadAwards];
                break;
            
            case CollectionTypeBets:
                [self loadBets];
                break;
                
            case CollectionTypeCatalogueEvents:
                [self loadCatalogueEvents];
                break;
                
            case CollectionTypeCatalogueTournaments:
                [self loadCatalogueTournaments];
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
            case CollectionTypeInviteFriends:
                [self loadFriendToInvite];
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
                
            case CollectionTypeParticipants:
                [self loadParticipants];
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
                [self loadTournament];
                break;
                
            case CollectionTypeTournamentEvents:
                [self loadTournamentEvents];
                break;
                
            case CollectionTypeTournaments:
                [self loadTournaments];
                break;
                
            case CollectionTypeUsers:
                [self loadUsers];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Activities

- (void)loadActivities
{
    if ([ObjectManager sharedManager].authorized)
    {
        UserModel *userModel = [self modifierOfClass:[UserModel class]];
        
        [[ObjectManager sharedManager] userWithModel:userModel
                                             success:^(UserModel *user)
            {
                [[ObjectManager sharedManager] activitiesForUser:user
                                                  paging:self.paging
                                                 success:^(NSArray *activities)
                                                 {
                                                     if (self.paging.isFirstPage)
                                                     {
                                                         NSArray *stationaryObjects = @[user];
                                                         self.stationaryObjectsCount = stationaryObjects.count;
                                                         [self combineStationaryObjects:stationaryObjects withNewObjects:activities];
                                                     }
                                                     else
                                                     {
                                                         [self combineWithObjects:activities];
                                                     }
                                                 }
                                                 failure:^
                                                 {
                                                     [self finishLoading];
                                                 }
                ];
            }
            failure:^
            {
                [self finishLoading];
            }
        ];
    }
    else
    {
        
        [self cleanCollection];
    }
}

- (void)loadActivitiesSelf
{
    [self loadActivities];
}

#pragma mark - Awards

- (void)loadAwards
{
    UserModel *user = [self modifierOfClass:[UserModel class]];
    
    [[ObjectManager sharedManager] awardsForUser:user
                                          paging:self.paging
                                         success:^(NSArray *awards)
                                         {
                                             [self combineWithObjects:awards];
                                         }
                                         failure:^
                                         {
                                             [self finishLoading];
                                         }
    ];
}

#pragma mark - Bets

- (void)loadBets
{
    if ([ObjectManager sharedManager].authorized)
    {
        [[ObjectManager sharedManager] betsWithPaging:self.paging success:^(NSArray *bets)
            {
                if (self.paging.isFirstPage)
                {
                    SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeMyStakes
                                                                     firstTitle:NSLocalizedString(@"Stakes", nil)
                                                                        firstOn:self.collectionType == CollectionTypeMyStakes ? YES : NO
                                                                     secondType:CollectionTypeBets
                                                                    secondTitle:NSLocalizedString(@"Bets", nil)
                                                                       secondOn:self.collectionType == CollectionTypeBets ? YES : NO];
                    NSArray *stationaryObjects = @[switchModel];
                    self.stationaryObjectsCount = stationaryObjects.count;
                    [self combineStationaryObjects:stationaryObjects withNewObjects:bets];
                }
                else
                {
                    [self combineWithObjects:bets];
                }
            }
            failure:^
            {
                [self finishLoading];
            }
        ];
    }
    else
    {
        [self cleanCollection];
    }
}

#pragma mark - Catalogue Events

- (void)loadCatalogueEvents
{
    [self clearGroups];
    
    [[ObjectManager sharedManager] groupsWithSuccess:^(NSArray *groups)
        {
            [self loadGroups:groups];
            
            PagingModel *paging = [PagingModel paging];
            [paging setDefaultLimit:@(TNCatalogueLeadLimit)];
            [paging firstPage];
            
            if ([ObjectManager sharedManager].authorized)
            {
                [self addHardcodedGroupsWithQuantity:self.search.query ? 3 : 2];
                
                [self loadCatalogueEventsUsersWithPaging:paging];
            }
            else
            {
                [self addHardcodedGroupsWithQuantity:self.search.query ? 2 : 1];
            }
            
            FilterModel *filter = [FilterModel filter];
            
            CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
            
            NSNumber *TNCategoryAll = @0;
            
            // Tournaments & Participants
            
            if (![category.tag isEqualToNumber:TNCategoryAll])
            {
                filter.categories = @[category];
                [self loadCatalogueEventsTournamentsWithPaging:paging filter:filter];
                if (self.search.query)
                {
                    [self loadCatalogueEventsParticipantsWithPaging:paging filter:filter];
                }
            }
            else
            {
                [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
                    {
                        filter.categories = includedCategories;
                        [self loadCatalogueEventsTournamentsWithPaging:paging filter:filter];
                        if (self.search.query)
                        {
                            [self loadCatalogueEventsParticipantsWithPaging:paging filter:filter];
                        }
                    }
                ];
            }
            
            // Events
            
            for (GroupModel *group in groups)
            {
                filter.group = group;
                
                if (![category.tag isEqualToNumber:TNCategoryAll])
                {
                    filter.categories = @[category];
                    [self loadCatalogueEventsWithGroup:group groups:groups paging:paging filter:filter];
                }
                else
                {
                    [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
                        {
                            filter.categories = includedCategories;
                            [self loadCatalogueEventsWithGroup:group groups:groups paging:paging filter:filter];
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

- (void)loadCatalogueEventsWithGroup:(GroupModel *)group
                              groups:(NSArray *)groups
                              paging:(PagingModel *)paging
                              filter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] eventsWithPaging:paging
                                             filter:filter
                                             search:self.search
                                            success:^(NSArray *events)
                                            {
                                                [self anotherGroupLoaded];
                                                [self replaceGroup:group inGroups:groups withObjects:events];
                                                if ([self allGroupsLoaded])
                                                {
                                                    [self combineCatalogueEvents];
                                                }
                                            }
                                            failure:^
                                            {
                                                [self finishLoading];
                                            }
    ];
}

- (void)loadCatalogueEventsUsersWithPaging:(PagingModel *)paging
{
    [[ObjectManager sharedManager] usersWithPaging:paging
                                            search:self.search
                                           success:^(NSArray *users)
                                           {
                                               [self anotherGroupLoaded];
                                               self.catalogueEventsUsers = users;
                                               if ([self allGroupsLoaded])
                                               {
                                                   [self combineCatalogueEvents];
                                               }
                                           }
                                           failure:^
                                           {
                                               [self finishLoading];
                                           }
    ];
}

- (void)loadCatalogueEventsParticipantsWithPaging:(PagingModel *)paging filter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] participantsWithPaging:paging
                                                   filter:filter
                                                   search:self.search
                                                  success:^(NSArray *participants)
                                                  {
                                                      [self anotherGroupLoaded];
                                                      self.catalogueEventsParticipants = participants;
                                                      if ([self allGroupsLoaded])
                                                      {
                                                          [self combineCatalogueEvents];
                                                      }
                                                  }
                                                  failure:^
                                                  {
                                                      [self finishLoading];
                                                  }
    ];
}

- (void)loadCatalogueEventsTournamentsWithPaging:(PagingModel *)paging filter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] tournamentsWithPaging:paging
                                                  filter:filter
                                                  search:self.search
                                                 success:^(NSArray *tournaments)
                                                 {
                                                     [self anotherGroupLoaded];
                                                     self.catalogueEventsTournaments = tournaments;
                                                     if ([self allGroupsLoaded])
                                                     {
                                                         [self combineCatalogueEvents];
                                                     }
                                                 }
                                                 failure:^
                                                 {
                                                     [self finishLoading];
                                                 }
    ];
}

- (void)combineCatalogueEvents
{
    NSMutableArray *combinedObjects = [NSMutableArray arrayWithObject:self.search ? : [SearchModel searchWithQuery:nil]];
    
    [combinedObjects addObjectsFromArray:[[self combinedGroupsWithObjects] copy]];
    
    if (self.catalogueEventsTournaments.count != 0)
    {
        [combinedObjects addObject:[self groupTournaments]];
        [combinedObjects addObjectsFromArray:self.catalogueEventsTournaments];
    }
    
    if (self.catalogueEventsUsers.count != 0)
    {
        [combinedObjects addObject:[self groupUsers]];
        [combinedObjects addObjectsFromArray:self.catalogueEventsUsers];
    }
    
    if (self.catalogueEventsParticipants.count != 0)
    {
        [combinedObjects addObject:[self groupParticipants]];
        [combinedObjects addObjectsFromArray:self.catalogueEventsParticipants];
    }
    
    self.collectionObjects = [combinedObjects copy];

    [self.collectionView reloadData];
    
    [self finishLoading];
}

#pragma mark - Catalogue Tournaments

- (void)loadCatalogueTournaments
{
    [self clearGroups];
    
    [[ObjectManager sharedManager] groupsWithSuccess:^(NSArray *groups)
        {
            [self loadGroups:groups];
            
            PagingModel *paging = [PagingModel paging];
            [paging setDefaultLimit:@(TNCatalogueLeadLimit)];
            [paging firstPage];
            
            for (GroupModel *group in groups)
            {
                FilterModel *filter = [FilterModel filter];
                filter.group = group;
                
                CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
                
                NSNumber *TNCategoryAll = @0;
                
                if (![category.tag isEqualToNumber:TNCategoryAll])
                {
                    filter.categories = @[category];
                    [self loadCatalogueTournamentsWithGroup:group groups:groups paging:paging filter:filter];
                }
                else
                {
                    [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
                        {
                            filter.categories = includedCategories;
                            [self loadCatalogueTournamentsWithGroup:group groups:groups paging:paging filter:filter];
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

- (void)loadCatalogueTournamentsWithGroup:(GroupModel *)group
                                   groups:(NSArray *)groups
                                   paging:(PagingModel *)paging
                                   filter:(FilterModel *)filter
{   
    [[ObjectManager sharedManager] tournamentsWithPaging:paging
                                                  filter:filter
                                                  search:self.search
                                                 success:^(NSArray *tournaments)
                                                 {
                                                     [self anotherGroupLoaded];
                                                     [self replaceGroup:group inGroups:groups withObjects:tournaments];
                                                     if ([self allGroupsLoaded])
                                                     {
                                                         [self combineCatalogueTournaments];
                                                     }
                                                 }
                                                 failure:^
                                                 {
                                                     [self finishLoading];
                                                 }
    ];
}

- (void)combineCatalogueTournaments
{
    NSMutableArray *combinedObjects = [NSMutableArray arrayWithObject:self.search ? : [SearchModel searchWithQuery:nil]];
    
    [combinedObjects addObjectsFromArray:[[self combinedGroupsWithObjects] copy]];
    
    self.collectionObjects = [combinedObjects copy];
    
    [self.collectionView reloadData];
    
    [self finishLoading];
}

#pragma mark - Event Comments

- (void)loadEventComments
{
    EventModel *event = [self modifierOfClass:[EventModel class]];
    
    [[ObjectManager sharedManager] scoresForEvent:event
                                          success:^(NSArray *scores)
                                          {
                                              event.scores = scores;
                                              [self combineEventCommentsWithEvent:event];
                                          }
                                          failure:^
                                          {
                                              [self finishLoading];
                                          }
    ];
}

- (void)combineEventCommentsWithEvent:(EventModel *)event
{
    if ([ObjectManager sharedManager].authorized)
    {
        [[ObjectManager sharedManager] commentsForEvent:event
                                                 paging:self.paging
                                                success:^(NSArray *comments)
                                                {
                                                    if (self.paging.isFirstPage)
                                                    {
                                                        SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeEventComments
                                                                                                         firstTitle:NSLocalizedString(@"Comments", nil)
                                                                                                            firstOn:self.collectionType == CollectionTypeEventComments ? YES : NO
                                                                                                         secondType:CollectionTypeEventStakes
                                                                                                        secondTitle:NSLocalizedString(@"Stakes", nil)
                                                                                                           secondOn:self.collectionType == CollectionTypeEventStakes ? YES : NO];
                                                        NSArray *stationaryObjects = @[event, switchModel];
                                                        self.stationaryObjectsCount = stationaryObjects.count;
                                                        [self combineStationaryObjects:stationaryObjects withNewObjects:comments];
                                                    }
                                                    else
                                                    {
                                                        [self combineWithObjects:comments];
                                                    }
                                                }
                                                failure:^
                                                {
                                                    [self finishLoading];
                                                }
        ];
    }
    else
    {
        NSArray *stationaryObjects = @[event];
        self.stationaryObjectsCount = stationaryObjects.count;
        [self combineStationaryObjects:stationaryObjects withNewObjects:@[]];
    }
}

#pragma mark - Events

- (void)loadEvents
{
    GroupModel *group = [self modifierOfClass:[GroupModel class]];
    
    FilterModel *filter = [FilterModel filter];
    filter.group = group;
    
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    NSNumber *TNCategoryAll = @0;
    if (![category.tag isEqualToNumber:TNCategoryAll])
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

- (void)loadEventsWithFilter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] eventsWithPaging:self.paging
                                             filter:filter
                                             search:self.search
                                            success:^(NSArray *events)
                                            {
                                                if (self.paging.isFirstPage)
                                                {
                                                    SearchModel *search = self.search ? : [SearchModel searchWithQuery:nil];
                                                    NSArray *stationaryObjects = @[search];
                                                    self.stationaryObjectsCount = stationaryObjects.count;
                                                    [self combineStationaryObjects:stationaryObjects withNewObjects:events];
                                                }
                                                else
                                                {
                                                    [self combineWithObjects:events];
                                                }
                                            }
                                            failure:^
                                            {
                                                [self finishLoading];
                                            }
    ];
}

#pragma mark - Event Stakes

- (void)loadEventStakes
{
    EventModel *event = [self modifierOfClass:[EventModel class]];
    
    [[ObjectManager sharedManager] scoresForEvent:event
                                          success:^(NSArray *scores)
                                          {
                                              event.scores = scores;
                                              [self combineEventStakesWithEvent:event];
                                          }
                                          failure:^
                                          {
                                              [self finishLoading];
                                          }
    ];
}

- (void)combineEventStakesWithEvent:(EventModel *)event
{
    if ([ObjectManager sharedManager].authorized)
    {
        [[ObjectManager sharedManager] stakesForEvent:event
                                               paging:self.paging
                                              success:^(NSArray *stakes)
                                              {
                                                  if (self.paging.isFirstPage)
                                                  {
                                                      SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeEventComments
                                                                                                       firstTitle:NSLocalizedString(@"Comments", nil)
                                                                                                          firstOn:self.collectionType == CollectionTypeEventComments ? YES : NO
                                                                                                       secondType:CollectionTypeEventStakes
                                                                                                      secondTitle:NSLocalizedString(@"Stakes", nil)
                                                                                                         secondOn:self.collectionType == CollectionTypeEventStakes ? YES : NO];
                                                      NSArray *stationaryObjects = @[event, switchModel];
                                                      self.stationaryObjectsCount = stationaryObjects.count;
                                                      [self combineStationaryObjects:stationaryObjects withNewObjects:stakes];
                                                  }
                                                  else
                                                  {
                                                      [self combineWithObjects:stakes];
                                                  }
                                              }
                                              failure:^
                                              {
                                                  [self finishLoading];
                                              }
        ];
    }
    else
    {
        NSArray *stationaryObjects = @[event];
        self.stationaryObjectsCount = stationaryObjects.count;
        [self combineStationaryObjects:stationaryObjects withNewObjects:@[]];
    }
}

#pragma mark - Invite Friends

- (void)loadFriendToInvite
{
    // Запрос к пунтр сереру на сравнение друзей полученных от FB
//    [ObjectManager sharedManager] loadFriendsToInvite
    
    
}

#pragma mark - My Stakes

- (void)loadMyStakes
{
    if ([ObjectManager sharedManager].authorized)
    {
        [[ObjectManager sharedManager] myStakesWithPaging:self.paging success:^(NSArray *stakes)
            {
                if (self.paging.isFirstPage)
                {
                    SwitchModel *switchModel = [SwitchModel switchWithFirstType:CollectionTypeMyStakes
                                                                     firstTitle:NSLocalizedString(@"Stakes", nil)
                                                                        firstOn:self.collectionType == CollectionTypeMyStakes ? YES : NO
                                                                     secondType:CollectionTypeBets
                                                                    secondTitle:NSLocalizedString(@"Bets", nil)
                                                                       secondOn:self.collectionType == CollectionTypeBets ? YES : NO];
                    NSArray *stationaryObjects = @[switchModel];
                    self.stationaryObjectsCount = stationaryObjects.count;
                    [self combineStationaryObjects:stationaryObjects withNewObjects:stakes];
                }
                else
                {
                    [self combineWithObjects:stakes];
                }
            }
            failure:^
            {
                [self finishLoading];
            }
        ];
    }
    else
    {
        [self cleanCollection];
    }
}

#pragma mark - News

- (void)loadNews
{
    if ([ObjectManager sharedManager].authorized)
    {
        [[ObjectManager sharedManager] newsWithPaging:self.paging
                                              success:^(NSArray *news)
                                              {
                                                  [self combineWithObjects:news];
                                              }
                                              failure:^
                                              {
                                                  [self finishLoading];
                                              }
        ];
    }
    else
    {
        [self cleanCollection];
    }
}

#pragma mark - Participant

- (void)loadParticipant
{
    ParticipantModel *participant = [self modifierOfClass:[ParticipantModel class]];
    
    [[ObjectManager sharedManager] eventsForParticipant:participant
                                                 paging:self.paging
                                                success:^(NSArray *events)
                                                {
                                                    if (self.paging.isFirstPage)
                                                    {
                                                        NSArray *stationaryObjects = @[participant];
                                                        self.stationaryObjectsCount = stationaryObjects.count;
                                                        [self combineStationaryObjects:stationaryObjects withNewObjects:events];
                                                    }
                                                    else
                                                    {
                                                        [self combineWithObjects:events];
                                                    }
                                                }
                                                failure:^
                                                {
                                                    [self finishLoading];
                                                }
    ];
}

#pragma mark - Participants

- (void)loadParticipants
{
    FilterModel *filter = [FilterModel filter];
    
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    NSNumber *TNCategoryAll = @0;
    if (![category.tag isEqualToNumber:TNCategoryAll])
    {
        filter.categories = @[category];
        [self loadParticipantsWithFilter:filter];
    }
    else
    {
        [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
            {
                filter.categories = includedCategories;
                [self loadParticipantsWithFilter:filter];
            }
        ];
    }
}

- (void)loadParticipantsWithFilter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] participantsWithPaging:self.paging
                                                   filter:filter
                                                   search:self.search
                                                  success:^(NSArray *participants)
                                                  {
                                                      if (self.paging.isFirstPage)
                                                      {
                                                          SearchModel *search = self.search ? : [SearchModel searchWithQuery:nil];
                                                          NSArray *stationaryObjects = @[search];
                                                          self.stationaryObjectsCount = stationaryObjects.count;
                                                          [self combineStationaryObjects:stationaryObjects withNewObjects:participants];
                                                      }
                                                      else
                                                      {
                                                          [self combineWithObjects:participants];
                                                      }
                                                  }
                                                  failure:^
                                                  {
                                                      [self finishLoading];
                                                  }
    ];
}

#pragma mark - Privacy Settings

- (void)loadPrivacySettings
{
    [[ObjectManager sharedManager] privacyWithSuccess:^(NSArray *privacy)
                                              {
                                                  [self combineWithObjects:privacy];
                                              }
                                              failure:^
                                              {
                                                  [self finishLoading];
                                              }
    ];
}

#pragma mark - Push Settings

- (void)loadPushSettings
{
    [[ObjectManager sharedManager] pushWithSuccess:^(NSArray *push)
                                           {
                                               [self combineWithObjects:push];
                                           }
                                           failure:^
                                           {
                                               [self finishLoading];
                                           }
    ];
}

#pragma mark - Socials Settings

- (void)loadSocialsSettings
{
    [[ObjectManager sharedManager] profileWithSuccess:^(UserModel *user)
        {
            UserModel *profile = user;

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
            vkDynamicModel.title = NSLocalizedString(@"VKontakte", nil);

            [self combineWithObjects:@[fbDynamicModel, twDynamicModel, vkDynamicModel]];
        }
        failure:^
        {
            [self finishLoading];
        }
    ];
}

#pragma mark - Subscribers

- (void)loadSubscribers
{
    UserModel *user = [self modifierOfClass:[UserModel class]];
    
    [[ObjectManager sharedManager] subscribersForUser:user
                                               paging:self.paging
                                              success:^(NSArray *subscribers)
                                              {
                                                  [self combineWithObjects:subscribers];
                                              }
                                              failure:^
                                              {
                                                  [self finishLoading];
                                              }
    ];
}

#pragma mark - Subscriptions

- (void)loadSubscriptions
{
    UserModel *user = [self modifierOfClass:[UserModel class]];
    
    [[ObjectManager sharedManager] subscriptionsForUser:user
                                                 paging:self.paging
                                                success:^(NSArray *subscriptions)
                                                {
                                                    [self combineWithObjects:subscriptions];
                                                }
                                                failure:^
                                                {
                                                    [self finishLoading];
                                                }
    ];
}

#pragma mark - Tournament

- (void)loadTournament
{
    [self clearGroups];
    
    [[ObjectManager sharedManager] groupsWithSuccess:^(NSArray *groups)
        {
            [self loadGroups:groups];

            PagingModel *paging = [PagingModel paging];
            [paging setDefaultLimit:@(TNCatalogueLeadLimit)];
            [paging firstPage];

            for (GroupModel *group in groups)
            {
                FilterModel *filter = [FilterModel filter];
                filter.group = group;

                CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];

                NSNumber *TNCategoryAll = @0;

                if (![category.tag isEqualToNumber:TNCategoryAll])
                {
                    filter.categories = @[category];
                    [self loadTournamentEventsWithGroup:group groups:groups paging:paging filter:filter];
                }
                else
                {
                    [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
                        {
                            filter.categories = includedCategories;
                            [self loadTournamentEventsWithGroup:group groups:groups paging:paging filter:filter];
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

- (void)loadTournamentEventsWithGroup:(GroupModel *)group
                               groups:(NSArray *)groups
                               paging:(PagingModel *)paging
                               filter:(FilterModel *)filter
{
    [[ObjectManager sharedManager] eventsForTournament:[self modifierOfClass:[TournamentModel class]]
                                                paging:paging
                                                filter:filter
                                                search:self.search
                                               success:^(NSArray *events)
                                               {
                                                   [self anotherGroupLoaded];
                                                   [self replaceGroup:group inGroups:groups withObjects:events];
                                                   if ([self allGroupsLoaded])
                                                   {
                                                       [self combineTournament];
                                                   }
                                               }
                                               failure:^
                                               {
                                                   [self finishLoading];
                                               }
    ];
}

- (void)combineTournament
{
    NSMutableArray *combinedObjects = [NSMutableArray array];
    
    TournamentModel *tournament = [self modifierOfClass:[TournamentModel class]];
    [combinedObjects addObject:tournament];
    
    SearchModel *search = self.search ? : [SearchModel searchWithQuery:nil];
    [combinedObjects addObject:search];
    
    [combinedObjects addObjectsFromArray:[self combinedGroupsWithObjects]];
    
    self.collectionObjects = [combinedObjects copy];
    
    [self.collectionView reloadData];
    
    [self finishLoading];
}

#pragma mark - Tournament Events

- (void)loadTournamentEvents
{
    GroupModel *group = [self modifierOfClass:[GroupModel class]];
    
    FilterModel *filter = [FilterModel filter];
    filter.group = group;
    
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    NSNumber *TNCategoryAll = @0;
    if (![category.tag isEqualToNumber:TNCategoryAll])
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
    [[ObjectManager sharedManager] eventsForTournament:[self modifierOfClass:[TournamentModel class]]
                                                paging:self.paging
                                                filter:filter
                                                search:self.search
                                               success:^(NSArray *events)
                                               {
                                                   if (self.paging.isFirstPage)
                                                   {
                                                       SearchModel *search = self.search ? : [SearchModel searchWithQuery:nil];
                                                       NSArray *stationaryObjects = @[search];
                                                       self.stationaryObjectsCount = stationaryObjects.count;
                                                       [self combineStationaryObjects:stationaryObjects withNewObjects:events];
                                                   }
                                                   else
                                                   {
                                                       [self combineWithObjects:events];
                                                   }
                                               }
                                               failure:^
                                               {
                                                   [self finishLoading];
                                               }
    ];
}
         
#pragma mark - Tournaments

- (void)loadTournaments
{
    GroupModel *group = [self modifierOfClass:[GroupModel class]];
    
    FilterModel *filter = [FilterModel filter];
    filter.group = group;
    
    CategoryModel *category = [CategoryModel categoryWithTag:[DefaultsManager sharedManager].defaultCategoryTag];
    NSNumber *TNCategoryAll = @0;
    if (![category.tag isEqualToNumber:TNCategoryAll])
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
    [[ObjectManager sharedManager] tournamentsWithPaging:self.paging
                                                  filter:filter
                                                  search:self.search
                                                 success:^(NSArray *tournaments)
                                                 {
                                                     if (self.paging.isFirstPage)
                                                     {
                                                         SearchModel *search = self.search ? : [SearchModel searchWithQuery:nil];
                                                         NSArray *stationaryObjects = @[search];
                                                         self.stationaryObjectsCount = stationaryObjects.count;
                                                         [self combineStationaryObjects:stationaryObjects withNewObjects:tournaments];
                                                     }
                                                     else
                                                     {
                                                         [self combineWithObjects:tournaments];
                                                     }
                                                 }
                                                 failure:^
                                                 {
                                                     [self finishLoading];
                                                 }
    ];
}

#pragma mark - Users

- (void)loadUsers
{
    [[ObjectManager sharedManager] usersWithPaging:self.paging
                                            search:self.search
                                           success:^(NSArray *users)
                                           {
                                               if (self.paging.isFirstPage)
                                               {
                                                   SearchModel *search = self.search ? : [SearchModel searchWithQuery:nil];
                                                   NSArray *stationaryObjects = @[search];
                                                   self.stationaryObjectsCount = stationaryObjects.count;
                                                   [self combineStationaryObjects:stationaryObjects withNewObjects:users];
                                               }
                                               else
                                               {
                                                   [self combineWithObjects:users];
                                               }
                                           }
                                           failure:^
                                           {
                                               [self finishLoading];
                                           }
    ];
}

#pragma mark - Combination

- (void)combineWithObjects:(NSArray *)newData
{
    if (newData.count)
    {
        BOOL finalData = (NSInteger)newData.count < self.paging.limit.integerValue;
        NSMutableArray *combinedData = [NSMutableArray arrayWithCapacity:self.collectionObjects.count + newData.count];
        NSMutableArray *oldData = [NSMutableArray arrayWithArray:self.collectionObjects];
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
        self.collectionObjects = [combinedData copy];
        
        [self.collectionView reloadData];
    }
    else
    {
        NSMutableArray *oldData = [NSMutableArray arrayWithArray:self.collectionObjects];
        if ([oldData.lastObject isMemberOfClass:[LoadModel class]])
        {
            [oldData removeLastObject];
        }
        self.collectionObjects = [oldData copy];
        
        [self.collectionView reloadData];
    }
    
    [self reportItems];
    
    [self finishLoading];
}

- (void)combineStationaryObjects:(NSArray *)stationaryObjects withNewObjects:(NSArray *)newObjects
{
    NSMutableArray *combined = [NSMutableArray arrayWithCapacity:newObjects.count + stationaryObjects.count];
    [combined addObjectsFromArray:stationaryObjects];
    [combined addObjectsFromArray:newObjects];
    
    [self combineWithObjects:[combined copy]];
}

- (void)finishLoading
{
    self.loading = NO;
    [self.refreshControl endRefreshing];
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionObjects.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TNLeadCellReuseIdentifier forIndexPath:indexPath];
    id model = self.collectionObjects[indexPath.row];
    if ([model isMemberOfClass:[LoadModel class]])
    {
        [self loadData];
    }
    [cell loadWithModel:model];
    cell.delegate = self;
    cell.searchDelegate = self;
    return cell;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [LeadCell sizeForModel:self.collectionObjects[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.collectionObjects[indexPath.row];
    if ([self.collectionManagerDelegate respondsToSelector:@selector(collectionViewDidSelectCellWithModel:)])
    {
        [self.collectionManagerDelegate collectionViewDidSelectCellWithModel:model];
    }
}

#pragma mark - SearchDelegate

- (void)cancelSearch
{
    self.search = nil;
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.collectionView endEditing:YES];
}

- (void)searchFor:(NSString *)query
{
    self.search = [SearchModel searchWithQuery:query];
    [self reloadData];
}

#pragma mark - Group Manipulation

- (void)loadGroups:(NSArray *)groups
{
    self.groupsCount = groups.count;
    self.groups = groups;
    [self.groupObjects addObjectsFromArray:groups];
}

- (void)clearGroups
{
    self.groupsLoaded = 0;
    self.groupsCount = 0;
    self.groups = nil;
    [self.groupObjects removeAllObjects];
}

- (void)anotherGroupLoaded
{
    self.groupsLoaded++;
}

- (void)addHardcodedGroupsWithQuantity:(NSUInteger)quantity
{
    self.groupsCount += quantity;
}

- (BOOL)allGroupsLoaded
{
    return self.groupsLoaded == self.groupsCount;
}

- (void)replaceGroup:(GroupModel *)group inGroups:(NSArray *)groups withObjects:(NSArray *)objects
{
    [self.groupObjects replaceObjectAtIndex:[groups indexOfObjectIdenticalTo:group] withObject:objects];
}

- (GroupModel *)groupOfObjects:(NSArray *)objects
{
    return self.groups[[self.groupObjects indexOfObjectIdenticalTo:objects]];
}

- (NSMutableArray *)combinedGroupsWithObjects
{
    NSMutableArray *combinedObjects = [NSMutableArray array];
    for (NSArray *objects in self.groupObjects)
    {
        if (objects.count == 0)
        {
            continue;
        }
        GroupModel *group = [self groupOfObjects:objects];
        [combinedObjects addObject:group];
        [combinedObjects addObjectsFromArray:objects];
    }
    return combinedObjects;
}

- (GroupModel *)groupParticipants
{
    GroupModel *groupParticipants = [GroupModel group];
    groupParticipants.slug = KeyParticipants;
    groupParticipants.title = NSLocalizedString(@"Participants", nil);
    groupParticipants.imageHardcode = [UIImage imageNamed:@"IconLiga"];
    return groupParticipants;
}

- (GroupModel *)groupTournaments
{
    GroupModel *groupTournaments = [GroupModel group];
    groupTournaments.slug = KeyTournaments;
    groupTournaments.title = NSLocalizedString(@"Tournaments", nil);
    groupTournaments.imageHardcode = [UIImage imageNamed:@"sectionTournaments"];
    return groupTournaments;
}

- (GroupModel *)groupUsers
{
    GroupModel *groupUsers = [GroupModel group];
    groupUsers.slug = KeyUsers;
    groupUsers.title = NSLocalizedString(@"Users", nil);
    groupUsers.imageHardcode = [UIImage imageNamed:@"IconExperts"];
    return groupUsers;
}

#pragma mark - Utility

- (void)cleanCollection
{
    self.stationaryObjectsCount = 0;
    self.collectionObjects = @[];
    [self combineWithObjects:@[]];
}

- (id)modifierOfClass:(Class)class
{
    return [self objectInArray:self.modifierObjects ofClass:class];
}

- (void)reportItems
{
    [self finishLoading];
    
    if ([self.collectionManagerDelegate respondsToSelector:@selector(haveItems:withCollectionType:)])
    {
        if (self.collectionObjects.count - self.stationaryObjectsCount <= 0)
        {
            [self.collectionManagerDelegate haveItems:NO withCollectionType:self.collectionType];
        }
        else
        {
            [self.collectionManagerDelegate haveItems:YES withCollectionType:self.collectionType];
        }
    }
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
