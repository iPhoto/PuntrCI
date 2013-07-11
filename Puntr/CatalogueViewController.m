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
#import "SectionModel.h"
#import "ObjectManager.h"
#import "EventModel.h"
#import "NotificationManager.h"
#import "SearchCell.h"
#import "CategoriesCell.h"
#import "EventViewController.h"

const CGSize eventItemSize = { 304.0f, 62.0f };
const CGSize headerSize = { 304.0f, 40.0f };
const CGSize searchSize = { 320.0f, 44.0f };
const CGSize categoriesSize = { 320.0f, 35.0f };
const UIEdgeInsets utilityInsets = { 0.0f, 0.0f, 8.0f, 0.0f };
const UIEdgeInsets sectionInsets = { 10.0f, 8.0f, 10.0f, 8.0f };

@interface CatalogueViewController ()

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CatalogueViewController

- (id)init {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 10.0f;
    _layout.minimumInteritemSpacing = 0.0f;
    self = [super initWithCollectionViewLayout:_layout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Каталог";

    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    
    
    self.collectionView.collectionViewLayout = self.layout;
    [self.collectionView registerClass:[EventCell class] forCellWithReuseIdentifier:@"CatalogueEventCell"];
    [self.collectionView registerClass:[HeaderCell class] forCellWithReuseIdentifier:@"CatalogueSectionHeader"];
    [self.collectionView registerClass:[SearchCell class] forCellWithReuseIdentifier:@"CatalogueSearchCell"];
    [self.collectionView registerClass:[CategoriesCell class] forCellWithReuseIdentifier:@"CatalogueCategoriesCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    SectionModel *sectionUtility = [[SectionModel alloc] init];
    sectionUtility.group = @"utility";
    
    SectionModel *sectionPopular = [[SectionModel alloc] init];
    sectionPopular.title = @"Популярное";
    sectionPopular.image = [UIImage imageNamed:@"sectionPopular"];
    sectionPopular.group = @"popular";
    
    SectionModel *sectionLive = [[SectionModel alloc] init];
    sectionLive.title = @"Идут сейчас";
    sectionLive.image = [UIImage imageNamed:@"sectionLive"];
    sectionLive.group = @"live";
    
    SectionModel *sectionTournaments = [[SectionModel alloc] init];
    sectionTournaments.title = @"Турниры";
    sectionTournaments.image = [UIImage imageNamed:@"sectionTournaments"];
    sectionTournaments.group = @"tournaments";
    
    SectionModel *sectionEditorsChoice = [[SectionModel alloc] init];
    sectionEditorsChoice.title = @"Выбор редакции";
    sectionEditorsChoice.image = [UIImage imageNamed:@"sectionEditorsChoice"];
    sectionEditorsChoice.group = @"editorsChoice";
    
    SectionModel *sectionMaximumWinnings = [[SectionModel alloc] init];
    sectionMaximumWinnings.title = @"Максимальный выигрыш!!!";
    sectionMaximumWinnings.image = [UIImage imageNamed:@"sectionMaximumWinnings"];
    sectionMaximumWinnings.group = @"maximumWinnings";
    
    self.sections = @[sectionUtility, sectionPopular, sectionLive, sectionTournaments];
    
    NSMutableArray *collectionData = [NSMutableArray arrayWithCapacity:self.sections.count];
    for (SectionModel *section in self.sections) {
        if (section == sectionUtility) {
            [collectionData addObject:[NSArray arrayWithObjects:[[SearchCell alloc] init], [[CategoriesCell alloc] init], nil]];
        } else {
            [collectionData addObject:@[section]];
        }
    }
    self.collectionData = [collectionData copy];
    [self updateSections];
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cellObject = self.collectionData[indexPath.section][indexPath.row];
    if ([cellObject isMemberOfClass:[SectionModel class]]) {
        SectionModel *section = (SectionModel *)cellObject;
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
        NSMutableArray *categories = [NSMutableArray arrayWithCapacity:10];
        for (NSUInteger counter = 0; counter < 10; counter++) {
            [categories addObject:[[CategoryModel alloc] init]];
        }
        [cell loadWithCategories:[categories copy]];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - CollectionView Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return utilityInsets;
    } else {
        return sectionInsets;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cellObject = self.collectionData[indexPath.section][indexPath.row];
    if ([cellObject isMemberOfClass:[SectionModel class]]) {
        return headerSize;
    } else if ([cellObject isMemberOfClass:[EventModel class]]) {
        return eventItemSize;
    } else if ([cellObject isMemberOfClass:[SearchCell class]]) {
        return searchSize;
    } else if ([cellObject isMemberOfClass:[CategoriesCell class]]) {
        return categoriesSize;
    } else {
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id cellObject = self.collectionData[indexPath.section][indexPath.row];
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
    [self updateSections];
}

- (void)updateSections {
    for (SectionModel *section in self.sections) {
        if (![section.group isEqualToString:@"utility"]) {
            [[ObjectManager sharedManager] eventsForGroup:section.group limit:@10 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [self updatedSection:section withMapping:mappingResult.array];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [NotificationManager showError:error forViewController:self];
            }];
        }
    }
}

- (void)updatedSection:(SectionModel *)section withMapping:(NSArray *)arrayMapping {
    NSUInteger sectionIndex = NSUIntegerMax;
    sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSUIntegerMax && sectionIndex != 0) {
        NSMutableArray *updatedSection = [arrayMapping mutableCopy];
        [updatedSection insertObject:section atIndex:0];
        
        NSMutableArray *mutableCollectionData = [self.collectionData mutableCopy];
        [mutableCollectionData replaceObjectAtIndex:sectionIndex withObject:[updatedSection copy]];
        
        self.collectionData = [mutableCollectionData copy];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        } completion:nil];
    }
}

@end
