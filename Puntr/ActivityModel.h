//
//  ActivityModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedModel.h"
#import "StakeModel.h"

@interface ActivityModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) StakeModel *stake;
@property (nonatomic, strong, readonly) FeedModel *feed;

@end
