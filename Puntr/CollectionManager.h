//
//  CollectionManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CollectionType)
{
    CollectionTypeMyStakes
};

@interface CollectionManager : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

#pragma mark - Convenience

+ (CollectionManager *)managerWithType:(CollectionType)collectionType;

#pragma mark - Configured CollectionView

- (UICollectionView *)collectionView;

#pragma mark - Data

- (void)reloadData;

@end