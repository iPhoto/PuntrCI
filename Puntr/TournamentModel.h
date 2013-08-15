//
//  TournamentModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"

@interface TournamentModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *banner;
@property (nonatomic, strong, readonly) NSNumber *stakesCount;
@property (nonatomic, strong, readonly) NSDate *startTime;
@property (nonatomic, strong, readonly) NSDate *endTime;
@property (nonatomic, strong, readonly) NSNumber *subscribed;
@property (nonatomic, strong, readonly) CategoryModel *category;

@end
