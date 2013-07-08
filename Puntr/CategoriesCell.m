//
//  CategoriesCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoriesCell.h"
#import "CategoryCell.h"

@interface CategoriesCell ()

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic) BOOL selectionOccured;

@end

@implementation CategoriesCell

- (void)loadWithCategories:(NSArray *)categories {
    self.categories = categories;
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = 0.0f;
    self.layout.minimumInteritemSpacing = 5.0f;
    self.layout.itemSize = CGSizeMake(49.0f, 35.0f);
    self.layout.sectionInset = UIEdgeInsetsZero;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.layout];
    [self.collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoriesCategoryCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
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
    if (!self.selectionOccured && indexPath.row == 0) {
        cell.selected = YES;
    }
    return cell;
}

@end
