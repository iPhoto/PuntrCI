//
//  NoDataManager.h
//  Puntr
//
//  Created by Alexander Lebedev on 9/19/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManagerDelegate.h"
#import <Foundation/Foundation.h>

@interface NoDataManager : NSObject <CollectionManagerDelegate>

@property (nonatomic, strong) UIView *view;

+ (NoDataManager *)managerWithType:(CollectionType)collectionType;

@end
