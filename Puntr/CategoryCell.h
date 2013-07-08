//
//  CategoryCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryModel;

@interface CategoryCell : UICollectionViewCell

- (void)loadWithCategory:(CategoryModel *)category;

@end
