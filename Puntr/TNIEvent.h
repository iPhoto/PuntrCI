//
//  TNIEvent.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TNICategory.h"
#import "TNIParticipants.h"

@interface TNIEvent : NSObject

@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, strong) NSNumber *stakesCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) TNICategory *category;
@property (nonatomic, strong) NSArray *participants;

@end
