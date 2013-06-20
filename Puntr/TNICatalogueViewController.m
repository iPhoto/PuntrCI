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

const CGSize eventItemSize = { 304.0f, 62.0f };
const CGFloat eventMinimumLineSpacing = 10.0f;
const CGFloat eventMinimumInteritemSpacing = 8.0f;
const UIEdgeInsets eventSectionInset = { 10.0f, 8.0f, 10.0f, 8.0f };

const CGSize eventHeaderSize = { 304.0f, 40.0f };

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
    [self.collectionView registerClass:[TNIHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CatalogueSectionHeader"];
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
    
    self.sections = @[sectionPopular, sectionLive, sectionTournaments, sectionEditorsChoice, sectionMaximumWinnings];
    
    
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TNIHeaderView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CatalogueSectionHeader" forIndexPath:indexPath];
    [header loadWithSection:self.sections[indexPath.section]];
    return header;
}

#pragma mark - CollectionView Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return eventSectionInset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return eventItemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return eventMinimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return eventMinimumLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return eventHeaderSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
