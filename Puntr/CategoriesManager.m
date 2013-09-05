//
//  CategoriesManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoriesManager.h"
#import "CategoryCell.h"
#import "ObjectManager.h"
#import "CategoryModel.h"

static NSString * const TNCategoryCellReuseIdentifier = @"CategoryCellReuseIdentifier";

@interface CategoriesManager ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic) NSUInteger selectionIndex;
@property (nonatomic) BOOL alreadyInitialized;

@end

@implementation CategoriesManager

#pragma mark - Convenience

+ (CategoriesManager *)manager
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self prepareCollectionView];
    }
    return self;
}

- (void)prepareCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 5.0f;
    layout.itemSize = CGSizeMake(49.0f, 35.0f);
    layout.sectionInset = UIEdgeInsetsZero;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:TNCategoryCellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
}

#pragma mark - Data

- (void)reloadData
{
    self.collectionData = nil;
    
    [[ObjectManager sharedManager] categoriesWithSuccess:^(NSArray *categories)
        {
            CategoryModel *categoryAll = [[CategoryModel alloc] init];
            categoryAll.tag = @0;
            categoryAll.title = @"Все";
            NSMutableArray *consolidatedCategories = [NSMutableArray arrayWithCapacity:categories.count + 1];
            [consolidatedCategories addObject:categoryAll];
            [consolidatedCategories addObjectsFromArray:categories];
            self.collectionData = [consolidatedCategories copy];
            [self.collectionView reloadData];
        }
        failure:nil
    ];
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
    CategoryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TNCategoryCellReuseIdentifier
                                                                        forIndexPath:indexPath];
    [cell loadWithCategory:self.collectionData[indexPath.row]];
    if (indexPath.row == (NSInteger)self.selectionIndex)
    {
        cell.selected = YES;
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectionIndex = (NSUInteger)indexPath.row;
    if (self.callback)
    {
        self.callback();
    }
}

@end