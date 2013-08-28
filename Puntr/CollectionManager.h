//
//  CollectionManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeadCell.h"

typedef NS_ENUM(NSInteger, CollectionType)
{
    CollectionTypeActivities,
    CollectionTypeAwards,
    CollectionTypeEventStakes,
    CollectionTypeMyStakes,
    CollectionTypeNews,
    CollectionTypeSubscriptions,
    CollectionTypePrivacySettings,
    CollectionTypePushSettinds
};

@interface CollectionManager : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, LeadCellDelegate>

#pragma mark - Convenience

+ (CollectionManager *)managerWithType:(CollectionType)collectionType modifierObject:(NSObject *)object;

#pragma mark - Configured CollectionView

- (UICollectionView *)collectionView;

#pragma mark - Data

- (void)reloadData;

@end