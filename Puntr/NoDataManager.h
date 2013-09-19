//
//  NoDataManager.h
//  Puntr
//
//  Created by Alexander Lebedev on 9/19/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionManagerDelegate.h"
typedef NS_ENUM(NSInteger, NoDataType)
{
    NoDataTypeNews,
    NoDataTypeStakes,
    NoDataTypeBets,
    NoDataTypeProfile,
    NoDataTypeOtherUser
};

@interface NoDataManager : NSObject<CollectionManagerDelegate>

@property (nonatomic, strong) UIView *view;

- (id)initWithNoDataOfType:(NoDataType)noDataType;

@end
