//
//  CatalogueViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CatalogueViewController.h"
#import "CategoriesCell.h"
#import "EventModel.h"
#import "EventViewController.h"
#import "FilterViewController.h"
#import "GroupModel.h"
#import "HeaderCell.h"
#import "LeadCell.h"
#import "LoadButtonCell.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "SearchCell.h"
#import "TournamentViewController.h"
#import "UIViewController+Puntr.h"

#define SECTION_SLUG_POPULAR        @"popular"
#define SECTION_SLUG_LIVE           @"live"
#define SECTION_SLUG_TOURNAMENTS    @"tournaments"
#define SECTION_SLUG_EDITORCHOISE   @"editorsChoice"
#define SECTION_SLUG_MAXWINNINGS    @"maximumWinnings"
#define SECTION_SLUG_UTILITY        @"utility"

const CGSize eventItemSize = { 304.0f, 62.0f };
const CGSize headerSize = { 304.0f, 40.0f };
const CGSize searchSize = { 304.0f, 44.0f };
const CGSize categoriesSize = { 320.0f, 35.0f };
const CGSize tournamentsSize = { 320.0f, 85.0f };
const CGSize buttonSize = { 304.0f, 48.0f };
const UIEdgeInsets utilityInsets = { 0.0f, 0.0f, 8.0f, 0.0f };
const UIEdgeInsets sectionInsets = { 10.0f, 8.0f, 10.0f, 8.0f };

@interface CatalogueViewController ()

@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) NSNumber *currentCategoryTag;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) GroupModel *selectedSection;
@property (nonatomic) NSUInteger currentPage;

@end

@implementation CatalogueViewController

- (id)init
{
    self = [self initWhithCategory:nil];
    return self;
}

- (id)initWhithCategory:(GroupModel *)selectedSection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 0.0f;
    if (self = [super initWithCollectionViewLayout:layout])
    {
        _selectedSection = selectedSection;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    UIButton *buttonFilter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonFilter setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonFilter setImage:[UIImage imageNamed:@"IconFilter"] forState:UIControlStateNormal];
    [buttonFilter setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    [buttonFilter addTarget:self action:@selector(touchedButtonFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:buttonFilter];
    self.navigationItem.leftBarButtonItem = settingsItem;
    
    [self.collectionView registerClass:[LeadCell class] forCellWithReuseIdentifier:@"CatalogueEventCell"];
    [self.collectionView registerClass:[HeaderCell class] forCellWithReuseIdentifier:@"CatalogueSectionHeader"];
    [self.collectionView registerClass:[LoadButtonCell class] forCellWithReuseIdentifier:@"CatalogueLoadButton"];
    [self.collectionView registerClass:[CategoriesCell class] forCellWithReuseIdentifier:@"CatalogueCategoriesCell"];
    [self.collectionView registerClass:[LeadCell class] forCellWithReuseIdentifier:@"CatalogueTournamentCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.currentPage = 0;
    self.currentCategoryTag = @0;
    
    GroupModel *sectionUtility = [[GroupModel alloc] init];
    sectionUtility.slug = SECTION_SLUG_UTILITY;
    if (!self.selectedSection)
    {
        self.title = @"Каталог";
        GroupModel *sectionPopular = [[GroupModel alloc] init];
        sectionPopular.title = @"Популярное";
        sectionPopular.slug = SECTION_SLUG_POPULAR;
        
        GroupModel *sectionLive = [[GroupModel alloc] init];
        sectionLive.title = @"Идут сейчас";
        sectionLive.slug = SECTION_SLUG_LIVE;
        
        GroupModel *sectionTournaments = [[GroupModel alloc] init];
        sectionTournaments.title = @"Турниры";
        sectionTournaments.slug = SECTION_SLUG_TOURNAMENTS;
        
        GroupModel *sectionEditorsChoice = [[GroupModel alloc] init];
        sectionEditorsChoice.title = @"Выбор редакции";
        sectionEditorsChoice.slug = SECTION_SLUG_EDITORCHOISE;
        
        GroupModel *sectionMaximumWinnings = [[GroupModel alloc] init];
        sectionMaximumWinnings.title = @"Максимальный выигрыш!!!";
        sectionMaximumWinnings.slug = SECTION_SLUG_MAXWINNINGS;
        
        self.sections = @[sectionUtility, sectionPopular, sectionLive, sectionTournaments];
    }
    else
    {
        self.title = self.selectedSection.title;
        self.sections = @[sectionUtility, self.selectedSection];
    }
    NSMutableArray *collectionData = [NSMutableArray arrayWithCapacity:self.sections.count];
    for (GroupModel *section in self.sections)
    {
        if (section == sectionUtility)
        {
            [collectionData addObject:[NSArray arrayWithObjects:[[CategoriesCell alloc] init], nil]];
        }
        else
        {
            [collectionData addObject:@[section]];
        }
    }
    self.collectionData = [collectionData copy];
    [self updateSections];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
}

#pragma mark - Sections work 

- (void)buildSectionsCatalogue {
    
}

- (void)buildTournamentsCatalogue {
    
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionData[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cellObject;
    if (self.selectedSection != nil)
    {
        cellObject = self.collectionData[indexPath.section][(indexPath.row + 1) % ([self.collectionData[indexPath.section] count])];
    }
    else
    {
        cellObject = self.collectionData[indexPath.section][indexPath.row];
    }
    if ([cellObject isMemberOfClass:[GroupModel class]])
    {
        if (self.selectedSection != nil)
        {
            LoadButtonCell *buttonLoad = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueLoadButton" forIndexPath:indexPath];
            buttonLoad.frame = buttonLoad.bounds;
            [buttonLoad loadButton];
            return buttonLoad;
        }
        GroupModel *section = (GroupModel *)cellObject;
        HeaderCell *header = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueSectionHeader" forIndexPath:indexPath];
        header.frame = header.bounds;
        [header loadWithSection:section];
        return header;
    }
    else if ([cellObject isMemberOfClass:[EventModel class]])
    {
        EventModel *event = (EventModel *)cellObject;
        LeadCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueEventCell" forIndexPath:indexPath];
        [cell loadWithModel:event];
        return cell;
    }
    else if ([cellObject isMemberOfClass:[SearchCell class]])
    {
        SearchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueSearchCell" forIndexPath:indexPath];
        cell.frame = cell.bounds;
        [cell loadSearchWithQuery:nil];
        return cell;
    }
    else if ([cellObject isMemberOfClass:[CategoriesCell class]])
    {
        CategoriesCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueCategoriesCell" forIndexPath:indexPath];
        cell.frame = cell.bounds;
        cell.selectedCategoryCallback = ^(NSNumber *selectedCategoryTag)
            {
                self.currentCategoryTag = selectedCategoryTag;
                [self updateSections];
            };
        [cell loadCategories];
        return cell;
    }
    else if ([cellObject isMemberOfClass:[TournamentModel class]])
    {
        TournamentModel *tournament = (TournamentModel *)cellObject;
        LeadCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueTournamentCell" forIndexPath:indexPath];
        [cell loadWithModel:tournament];
        return cell;
    }
    else
    {
        return nil;
    }
}

#pragma mark - CollectionView Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0)
    {
        return utilityInsets;
    }
    else
    {
        return sectionInsets;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cellObject;
    if (self.selectedSection != nil)
    {
        cellObject = self.collectionData[indexPath.section][(indexPath.row + 1) % ([self.collectionData[indexPath.section] count])];
    }
    else
    {
        cellObject = self.collectionData[indexPath.section][indexPath.row];
    }
    
    if ([cellObject isMemberOfClass:[GroupModel class]])
    {
        if (self.selectedSection != nil)
        {
            return buttonSize;
        }
        return headerSize;
    }
    else if ([cellObject isMemberOfClass:[EventModel class]])
    {
        return [LeadCell sizeForModel:(EventModel *)cellObject];
    }
    else if ([cellObject isMemberOfClass:[SearchCell class]])
    {
        return searchSize;
    }
    else if ([cellObject isMemberOfClass:[CategoriesCell class]])
    {
        return categoriesSize;
    }
    else if ([cellObject isMemberOfClass:[TournamentModel class]])
    {
        return [LeadCell sizeForModel:(TournamentModel *)cellObject];;
    }
    else
    {
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cellObject;
    if (self.selectedSection != nil)
    {
        cellObject = self.collectionData[indexPath.section][(indexPath.row + 1) % ([self.collectionData[indexPath.section] count])];
        if ([cellObject isMemberOfClass:[GroupModel class]])
        {
            NSLog(@"section clicked");
            [self buttonStakeTouched];
        }
    }
    else
    {
        cellObject = self.collectionData[indexPath.section][indexPath.row];
        if ([cellObject isMemberOfClass:[GroupModel class]])
        {
            NSLog(@"section clicked");
            [self.navigationController pushViewController:[[CatalogueViewController alloc] initWhithCategory:cellObject] animated:YES];
        }
    }
    
    if ([cellObject isMemberOfClass:[EventModel class]])
    {
        EventModel *event = (EventModel *)cellObject;
        [self.navigationController pushViewController:[[EventViewController alloc] initWithEvent:event] animated:YES];
    }
    if ([cellObject isMemberOfClass:[TournamentModel class]])
    {
        TournamentModel *tournament = (TournamentModel *)cellObject;
        [self.navigationController pushViewController:[[TournamentViewController alloc] initWithTounament:tournament] animated:YES];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell resignFirstResponder];
    }
}

#pragma mark - Logic

- (void)buttonStakeTouched
{
    self.currentPage++;
    [self updateSections];
}

- (void)touchedButtonFilter
{
    FilterViewController *filterViewController = [FilterViewController new];
    [self.navigationController pushViewController:filterViewController animated:YES];
}

- (void)updateSections
{
    for (GroupModel *section in self.sections)
    {
        if (![section.slug isEqualToString:SECTION_SLUG_UTILITY])
        {
            if ([self.selectedSection.slug isEqualToString:SECTION_SLUG_TOURNAMENTS])
            {
                // get tournaments list from server
                __weak CatalogueViewController* weakSelf = self;
                [[ObjectManager sharedManager] tournamentsForGroup:section.slug
                                                            filter:@[self.currentCategoryTag]
                                                            search:nil limit:@10
                                                              page:[NSNumber numberWithInt:self.currentPage]
                                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                                           {
                                                               [weakSelf updatedSection:section withMapping:mappingResult.array];
                                                           }
                                                           failure:^(RKObjectRequestOperation *operation, NSError *error)
                                                           {
                                                               [NotificationManager showError:error forViewController:weakSelf];
                                                           }
                
                ];
            }
            else
            {
                __weak CatalogueViewController* weakSelf = self;
                [[ObjectManager sharedManager] eventsForGroup:section.slug
                                                       filter:@[self.currentCategoryTag]
                                                       search:nil limit:@10
                                                         page:[NSNumber numberWithInt:self.currentPage]
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                                      {
                                                          [weakSelf updatedSection:section withMapping:mappingResult.array];
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                                      {
                                                          [NotificationManager showError:error forViewController:weakSelf];
                                                      }
                ];
            }
        }
    }
}

- (void)updatedSection:(GroupModel *)section withMapping:(NSArray *)arrayMapping
{
    NSUInteger sectionIndex = NSUIntegerMax;
    sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSUIntegerMax && sectionIndex != 0)
    {
        NSMutableArray *updatedSection = [arrayMapping mutableCopy];
        [updatedSection insertObject:section atIndex:0];
        
        NSMutableArray *mutableCollectionData = [self.collectionData mutableCopy];
        if (self.currentPage > 0)
        {
            NSMutableArray *mutableSection = [mutableCollectionData[sectionIndex] mutableCopy];
            [updatedSection removeObjectAtIndex:0];
            [mutableSection addObjectsFromArray:updatedSection];
            if (updatedSection.count < 10)
            {
                [mutableSection removeObjectAtIndex:0];
            }
            mutableCollectionData[sectionIndex] = [mutableSection copy];
        }
        else
        {
            [mutableCollectionData replaceObjectAtIndex:sectionIndex withObject:[updatedSection copy]];
        }
        self.collectionData = [mutableCollectionData copy];
        [self.collectionView performBatchUpdates: ^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        } completion:nil];
    }
}

@end
