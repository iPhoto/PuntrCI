//
//  CategoriesCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesCell : UICollectionViewCell <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

- (void)loadWithCategories:(NSArray *)categories;

@end
