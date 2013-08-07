//
//  CategoriesCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoriesCell.h"
#import "CategoryCell.h"
#import "ObjectManager.h"
#import "CategoryModel.h"
#import "NotificationManager.h"

@interface CategoriesCell ()

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic) NSUInteger selectionIndex;
@property (nonatomic) BOOL alreadyInitialized;

@end

@implementation CategoriesCell

- (void)loadCategories {
    if (!self.alreadyInitialized) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = 0.0f;
        self.layout.minimumInteritemSpacing = 5.0f;
        self.layout.itemSize = CGSizeMake(49.0f, 35.0f);
        self.layout.sectionInset = UIEdgeInsetsZero;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.layout];
        [self.collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoriesCategoryCell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.bounces = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
    }
    self.alreadyInitialized = YES;
    [self reload];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CategoriesCategoryCell" forIndexPath:indexPath];
    [cell loadWithCategory:self.categories[indexPath.row]];
    if (indexPath.row == (NSInteger)self.selectionIndex) {
        cell.selected = YES;
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectionIndex = (NSUInteger)indexPath.row;
    if (self.selectedCategoryCallback) {
        CategoryModel *selectedCategory = self.categories[self.selectionIndex];
        self.selectedCategoryCallback(selectedCategory.tag);
    }
}

- (void)reload {
    [[ObjectManager sharedManager] categoriesWithSuccess:^(NSArray *categories) {
        CategoryModel *categoryAll = [[CategoryModel alloc] init];
        categoryAll.tag = @0;
        categoryAll.title = @"Все";
        NSMutableArray *consolidatedCategories = [NSMutableArray arrayWithCapacity:categories.count + 1];
        [consolidatedCategories addObject:categoryAll];
        [consolidatedCategories addObjectsFromArray:categories];
        self.categories = [consolidatedCategories copy];
        [self.collectionView reloadData];
    } failure:nil];
}

- (void)prepareForReuse {
    self.categories = nil;
}

@end
