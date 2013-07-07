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

const CGSize eventItemSize = { 304.0f, 62.0f };
const CGFloat eventMinimumLineSpacing = 10.0f;
const CGFloat eventMinimumInteritemSpacing = 0.0f;
const UIEdgeInsets eventSectionInset = { 10.0f, 8.0f, 10.0f, 8.0f };

const CGSize headerSize = { 304.0f, 40.0f };

@interface CatalogueViewController ()

@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) NSArray *sections;

@end

@implementation CatalogueViewController

- (id)init
{
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Каталог";

    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self.collectionView registerClass:[EventCell class] forCellWithReuseIdentifier:@"CatalogueEventCell"];
    [self.collectionView registerClass:[HeaderCell class] forCellWithReuseIdentifier:@"CatalogueSectionHeader"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
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
    
    self.sections = @[sectionPopular, sectionLive];
    
    NSMutableArray *collectionData = [NSMutableArray arrayWithCapacity:self.sections.count];
    for (SectionModel *section in self.sections) {
        [collectionData addObject:@[section]];
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
    if (indexPath.row == 0) {
        HeaderCell *header = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueSectionHeader" forIndexPath:indexPath];
        [header loadWithSection:self.sections[indexPath.section]];
        return header;
    } else {
        EventCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueEventCell" forIndexPath:indexPath];
        EventModel *event = self.collectionData[indexPath.section][indexPath.row];
        [cell loadWithEvent:event];
        [cell.buttonStake addTarget:self action:@selector(buttonStakeTouched) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark - CollectionView Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return eventSectionInset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? headerSize : eventItemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return eventMinimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return eventMinimumLineSpacing;
}

#pragma mark - Logic

- (void)buttonStakeTouched {
    [self updateSections];
}

- (void)updateSections {
    for (SectionModel *section in self.sections) {
        [[ObjectManager sharedManager] eventsForGroup:section.group limit:@10 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self updatedSection:section withMapping:mappingResult.array];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [NotificationManager showError:error forViewController:self];
        }];
    }
}

- (void)updatedSection:(SectionModel *)section withMapping:(NSArray *)arrayMapping {
    NSUInteger sectionIndex = NSUIntegerMax;
    sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSUIntegerMax) {
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
