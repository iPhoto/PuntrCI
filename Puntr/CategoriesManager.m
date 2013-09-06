//
//  CategoriesManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoriesManager.h"
#import "CategoryCell.h"
#import "DefaultsManager.h"
#import "CategoryModel.h"

static NSString * const TNCategoryCellReuseIdentifier = @"CategoryCellReuseIdentifier";

@interface CategoriesManager ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionData;
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
    _collectionView.backgroundColor = [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.00f];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
}

#pragma mark - Data

- (void)reloadData
{
    self.collectionData = nil;
    
    [CategoryModel includedCategoriesWithSuccess:^(NSArray *includedCategories)
        {
            CategoryModel *categoryAll = [[CategoryModel alloc] init];
            categoryAll.tag = @0;
            categoryAll.title = @"Все";
            NSMutableArray *consolidatedCategories = [NSMutableArray arrayWithCapacity:includedCategories.count + 1];
            [consolidatedCategories addObject:categoryAll];
            [consolidatedCategories addObjectsFromArray:includedCategories];
            self.collectionData = [consolidatedCategories copy];
            [self.collectionView reloadData];
        }
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
    CategoryModel *category = self.collectionData[indexPath.row];
    [cell loadWithCategory:category];
    if ([category.tag isEqualToNumber:[DefaultsManager sharedManager].defaultCategoryTag])
    {
        cell.selected = YES;
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *category = self.collectionData[indexPath.row];
    [DefaultsManager sharedManager].defaultCategoryTag = category.tag;
    if (self.callback)
    {
        self.callback();
    }
}

@end
