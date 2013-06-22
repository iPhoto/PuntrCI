//
//  TNICatalogueViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNICatalogueViewController.h"
#import "TNIHeaderView.h"
#import "TNIEventCell.h"
#import "TNISection.h"
#import "TNIObjectManager.h"
#import "TNIEvent.h"

const CGSize eventItemSize = { 304.0f, 62.0f };
const CGFloat eventMinimumLineSpacing = 10.0f;
const CGFloat eventMinimumInteritemSpacing = 0.0f;
const UIEdgeInsets eventSectionInset = { 10.0f, 8.0f, 10.0f, 8.0f };

const CGSize headerSize = { 304.0f, 40.0f };

@interface TNICatalogueViewController ()

@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) NSArray *sections;

@end

@implementation TNICatalogueViewController

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
    
    [self.collectionView registerClass:[TNIEventCell class] forCellWithReuseIdentifier:@"CatalogueEventCell"];
    [self.collectionView registerClass:[TNIHeaderView class] forCellWithReuseIdentifier:@"CatalogueSectionHeader"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    TNISection *sectionPopular = [[TNISection alloc] init];
    sectionPopular.title = @"Популярное";
    sectionPopular.image = [UIImage imageNamed:@"sectionPopular"];
    sectionPopular.group = @"popular";
    
    TNISection *sectionLive = [[TNISection alloc] init];
    sectionLive.title = @"Идут сейчас";
    sectionLive.image = [UIImage imageNamed:@"sectionLive"];
    sectionLive.group = @"live";
    
    TNISection *sectionTournaments = [[TNISection alloc] init];
    sectionTournaments.title = @"Турниры";
    sectionTournaments.image = [UIImage imageNamed:@"sectionTournaments"];
    sectionTournaments.group = @"tournaments";
    
    TNISection *sectionEditorsChoice = [[TNISection alloc] init];
    sectionEditorsChoice.title = @"Выбор редакции";
    sectionEditorsChoice.image = [UIImage imageNamed:@"sectionEditorsChoice"];
    sectionEditorsChoice.group = @"editorsChoice";
    
    TNISection *sectionMaximumWinnings = [[TNISection alloc] init];
    sectionMaximumWinnings.title = @"Максимальный выигрыш!!!";
    sectionMaximumWinnings.image = [UIImage imageNamed:@"sectionMaximumWinnings"];
    sectionMaximumWinnings.group = @"maximumWinnings";
    
    self.sections = @[sectionPopular, sectionLive];
    
    NSMutableArray *collectionData = [NSMutableArray arrayWithCapacity:self.sections.count];
    for (TNISection *section in self.sections) {
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
        TNIHeaderView *header = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueSectionHeader" forIndexPath:indexPath];
        [header loadWithSection:self.sections[indexPath.section]];
        return header;
    } else {
        TNIEventCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogueEventCell" forIndexPath:indexPath];
        TNIEvent *event = self.collectionData[indexPath.section][indexPath.row];
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
    for (TNISection *section in self.sections) {
        [[TNIObjectManager sharedManager] eventsForGroup:section.group limit:@10 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self updatedSection:section withMapping:mappingResult.array];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (void)updatedSection:(TNISection *)section withMapping:(NSArray *)arrayMapping {
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
