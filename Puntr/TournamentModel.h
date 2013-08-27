//
//  TournamentModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"
#import "Parametrization.h"

@interface TournamentModel : NSObject <Parametrization>

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *banner;
@property (nonatomic, strong, readonly) NSNumber *stakesCount;
@property (nonatomic, strong, readonly) NSNumber *subscribersCount;
@property (nonatomic, strong, readonly) NSDate *startTime;
@property (nonatomic, strong, readonly) NSDate *endTime;
@property (nonatomic, strong) NSNumber *subscribed;
@property (nonatomic, strong, readonly) CategoryModel *category;

- (NSDictionary *)wrappedParameters;

@end
