//
//  CatalogueViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CatalogueViewController.h"
#import "HeaderCell.h"
#import "EventCell.h"
#import "LoadButtonCell.h"
#import "TournamentCell.h"
#import "GroupModel.h"
#import "ObjectManager.h"
#import "EventModel.h"
#import "NotificationManager.h"
#import "SearchCell.h"
#import "CategoriesCell.h"
#import "EventViewController.h"
#import "UIViewController+Puntr.h"

const CGSize eventItemSize = { 304.0f, 62.0f };
const CGSize headerSize = { 304.0f, 40.0f };
const CGSize searchSize = { 304.0f, 44.0f };
const CGSize categoriesSize = { 320.0f, 35.0f };
const CGSize tournamentsSize = { 320.0f, 35.0f };
const CGSize buttonSize = { 304.0f, 48.0f };
const UIEdgeInsets utilityInsets = { 0.0f, 0.0f, 8.0f, 0.0f };
const UIEdgeInsets sectionInsets = { 10.0f, 8.0f, 10.0f, 8.0f };

@interface CatalogueViewController ()

@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) NSNumber *currentCategoryTag;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) GroupModel *selectedSection;
@property () int currentPage;

@end

@implementation CatalogueViewController

- (id)init {
    self = [self initWhithCategory:nil];
    return self;
}

- (id)initWhithCategory:(GroupModel *)selectedSection {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 0.0f;
    if (self = [super initWithCollectionViewLayout:layout]) {
        _selectedSection = selectedSection;
    }
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    [self.collectionView registerClass:[EventCell class] forCellWithReuseIdentifier:@"CatalogueEventCell"];
    [self.collectionView registerClass:[HeaderCell class] forCellWithReuseIdentifier:@"CatalogueSectionHeader"];
    [self.collectionView registerClass:[LoadButtonCell class] forCellWithReuseIdentifier:@"CatalogueLoadButton"];
    [self.collectionView registerClass:[CategoriesCell class] forCellWithReuseIdentifier:@"CatalogueCategoriesCell"];
    [self.collectionView registerClass:[TournamentCell class] forCellWithReuseIdentifier:@"CatalogueTournamentCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.currentPage = 0;
    self.currentCategoryTag = @0;
    
    GroupModel *sectionUtility = [[GroupModel alloc] init];
    sectionUtility.slug = @"utility";
    if (self.selectedSection == nil) {
        self.title = @"Каталог";
        GroupModel *sectionPopular = [[GroupModel alloc] init];
        sectionPopular.title = @"Популярное";
        sectionPopular.image = [UIImage imageNamed:@"sectionPopular"];
        sectionPopular.slug = @"popular";
        
        GroupModel *sectionLive = [[GroupModel alloc] init];
        sectionLive.title = @"Идут сейчас";
        sectionLive.image = [UIImage imageNamed:@"sectionLive"];
        sectionLive.slug = @"live";
        
        GroupModel *sectionTournaments = [[GroupModel alloc] init];
        sectionTournaments.title = @"Турниры";
        sectionTournaments.image = [UIImage imageNamed:@"sectionTournaments"];
        sectionTournaments.slug = @"tournaments";
        
        GroupModel *sectionEditorsChoice = [[GroupModel alloc] init];
        sectionEditorsChoice.title = @"Выбор редакции";
        sectionEditorsChoice.image = [UIImage imageNamed:@"sectionEditorsChoice"];
        sectionEditorsChoice.slug = @"editorsChoice";
        
        GroupModel *sectionMaximumWinnings = [[GroupModel alloc] init];
        sectionMaximumWinnings.title = @"Максимальный выигрыш!!!";
        sectionMaximumWinnings.image = [UIImage imageNamed:@"sectionMaximumWinnings"];
        sectionMaximumWinnings.slug = @"maximumWinnings";
        
        self.sections = @[sectionUtility, sectionPopular, sectionLive, sectionTournaments];
    } else {
        self.title = self.selectedSection.title;
        self.sections = @[sectionUtility, self.selectedSection];
    }
    NSMutableArray *collectionData = [NSMutableArray arrayWithCapacity:self.sections.count];
    for (GroupModel *section in self.sections) {
        if (section == sectionUtility) {
            [collectionData addObject:[NSArray arrayWithObjects:[[CategoriesCell alloc] init], nil]];
        } else {
            [collectionData addObject:@[section]];
        }
    }
    self.collectionData = [collectionData copy];
    [self updateSections];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateBalance];
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cellObject;     //= self.collectionData[indexPath.section][indexPath.row];
    if (self.selectedSection != nil) {
        cellObject = self.collectionData[indexPath.section][(indexPath.row + 1) % ([self.collectionData[indexPath.section] count])];
    } else {
        cellObject = self.collectionData[indexPath.section][indexPath.row];
    }
    if ([cellObject isMemberOfClass:[GroupModel class]]) {
        if (self.selectedSection != nil) {
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
    } else if ([cellObject isMemberOfClass:[EventModel class]]) {
        EventModel *event = (EventModel *)cellObject;
        EventCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueEventCell" forIndexPath:indexPath];
        cell.frame = cell.bounds;
        [cell loadWithEvent:event];
        [cell.buttonStake addTarget:self action:@selector(buttonStakeTouched) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([cellObject isMemberOfClass:[SearchCell class]]) {
        SearchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueSearchCell" forIndexPath:indexPath];
        cell.frame = cell.bounds;
        [cell loadSearchWithQuery:nil];
        return cell;
    } else if ([cellObject isMemberOfClass:[CategoriesCell class]]) {
        CategoriesCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueCategoriesCell" forIndexPath:indexPath];
        cell.frame = cell.bounds;
        cell.selectedCategoryCallback = ^(NSNumber *selectedCategoryTag) {
            self.currentCategoryTag = selectedCategoryTag;
            [self updateSections];
        };
        [cell loadCategories];
        return cell;
    } else if ([cellObject isMemberOfClass:[TournamentCell class]]) {
        TournamentModel *tournament = (TournamentModel *)cellObject;
        TournamentCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueTournamentCell" forIndexPath:indexPath];
        cell.frame = cell.bounds;
        [cell loadWithTournament:tournament];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - CollectionView Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return utilityInsets;
    } else {
        return sectionInsets;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //id cellObject = self.collectionData[indexPath.section][indexPath.row];
    id cellObject;
    if (self.selectedSection != nil) {
        cellObject = self.collectionData[indexPath.section][(indexPath.row + 1) % ([self.collectionData[indexPath.section] count])];
    } else {
        cellObject = self.collectionData[indexPath.section][indexPath.row];
    }
    if ([cellObject isMemberOfClass:[GroupModel class]]) {
        if (self.selectedSection != nil) {
            return buttonSize;
        }
        return headerSize;
    } else if ([cellObject isMemberOfClass:[EventModel class]]) {
        return eventItemSize;
    } else if ([cellObject isMemberOfClass:[SearchCell class]]) {
        return searchSize;
    } else if ([cellObject isMemberOfClass:[CategoriesCell class]]) {
        return categoriesSize;
    } else if ([cellObject isMemberOfClass:[TournamentCell class]]) {
        return tournamentsSize;
    } else {
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //id cellObject = self.collectionData[indexPath.section][indexPath.row];
    id cellObject;
    if (self.selectedSection != nil) {
        cellObject = self.collectionData[indexPath.section][(indexPath.row + 1) % ([self.collectionData[indexPath.section] count])];
        if ([cellObject isMemberOfClass:[GroupModel class]]) {
            NSLog(@"section clicked");
            [self buttonStakeTouched];
        }
    } else {
        cellObject = self.collectionData[indexPath.section][indexPath.row];
        if ([cellObject isMemberOfClass:[GroupModel class]]) {
            NSLog(@"section clicked");
            [self.navigationController pushViewController:[[CatalogueViewController alloc] initWhithCategory:cellObject] animated:YES];
        }
    }
    
    if ([cellObject isMemberOfClass:[EventModel class]]) {
        EventModel *event = (EventModel *)cellObject;
        [self.navigationController pushViewController:[[EventViewController alloc] initWithEvent:event] animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell resignFirstResponder];
    }
}

#pragma mark - Logic

- (void)buttonStakeTouched {
    self.currentPage++;
    [self updateSections];
}

- (void)updateSections {
    for (GroupModel *section in self.sections) {
        if (![section.slug isEqualToString:@"utility"]) {
            [[ObjectManager sharedManager] eventsForGroup:section.slug filter:@[self.currentCategoryTag] search:nil limit:@10 page:[NSNumber numberWithInt:self.currentPage] success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [self updatedSection:section withMapping:mappingResult.array];
            } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                [NotificationManager showError:error forViewController:self];
            }];
        }
    }
}

- (void)updatedSection:(GroupModel *)section withMapping:(NSArray *)arrayMapping {
    NSUInteger sectionIndex = NSUIntegerMax;
    sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSUIntegerMax && sectionIndex != 0) {
        NSMutableArray *updatedSection = [arrayMapping mutableCopy];
        [updatedSection insertObject:section atIndex:0];
        
        NSMutableArray *mutableCollectionData = [self.collectionData mutableCopy];
        if (self.currentPage > 0) {
            NSMutableArray *mutableSection = [mutableCollectionData[sectionIndex] mutableCopy];
            [updatedSection removeObjectAtIndex:0];
            [mutableSection addObjectsFromArray:updatedSection];
            if (updatedSection.count < 10) {
                [mutableSection removeObjectAtIndex:0];
            }
            mutableCollectionData[sectionIndex] = [mutableSection copy];
        } else {
            [mutableCollectionData replaceObjectAtIndex:sectionIndex withObject:[updatedSection copy]];
        }
        self.collectionData = [mutableCollectionData copy];
        [self.collectionView performBatchUpdates: ^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        } completion:nil];
    }
}

@end
