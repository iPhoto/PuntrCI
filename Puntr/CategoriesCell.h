//
//  CategoriesCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedCategory)(NSNumber *selectedCategoryTag);

@interface CategoriesCell : UICollectionViewCell <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) SelectedCategory selectedCategoryCallback;

- (void)loadCategories;

@end
