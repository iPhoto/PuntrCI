//
//  EventModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"
#import "ParticipantModel.h"
#import "LineModel.h"

@interface EventModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSNumber *stakesCount;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSDate *startTime;
@property (nonatomic, strong, readonly) NSDate *endTime;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, strong, readonly) CategoryModel *category;
@property (nonatomic, strong, readonly) NSArray *participants;
@property (nonatomic, strong, readonly) NSArray *lines;

@end
