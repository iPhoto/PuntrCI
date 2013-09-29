//
//  CollectionManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeadCellDelegate.h"
#import "CollectionManagerDelegate.h"
#import "CollectionManagerTypes.h"
#import "SearchDelegate.h"

@interface CollectionManager : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, LeadCellDelegate, SearchDelegate>

@property (nonatomic, weak) id <CollectionManagerDelegate> collectionManagerDelegate;

#pragma mark - Convenience

+ (CollectionManager *)managerWithType:(CollectionType)collectionType modifierObjects:(NSArray *)objects;

#pragma mark - Configured CollectionView

- (UICollectionView *)collectionView;

#pragma mark - Reload

- (void)reloadData;

- (void)switchToType:(CollectionType)collectionType;

@end