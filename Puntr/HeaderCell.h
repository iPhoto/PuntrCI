//
//  HeaderCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupModel;

@interface HeaderCell : UICollectionViewCell

- (void)loadWithSection:(GroupModel *)section;

@end