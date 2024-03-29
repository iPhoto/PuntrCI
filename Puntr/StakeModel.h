//
//  StakeModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 12.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "EventModel.h"
#import "LineModel.h"
#import "ComponentModel.h"
#import "CoefficientModel.h"
#import "MoneyModel.h"

@interface StakeModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, strong, readonly) UserModel *user;
@property (nonatomic, strong) EventModel *event;
@property (nonatomic, strong, readonly) LineModel *line;
@property (nonatomic, strong, readonly) CoefficientModel *coefficient;
@property (nonatomic, strong, readonly) MoneyModel *money;

// Stake Creation

+ (StakeModel *)stakeWithEvent:(EventModel *)event
                          line:(LineModel *)line
                   coefficient:(CoefficientModel *)coefficient
                         money:(MoneyModel *)money;

- (void)prepareForTransmission;

// Coefficient Query

+ (StakeModel *)stakeWithEvent:(EventModel *)event line:(LineModel *)line;

- (NSDictionary *)parameters;

- (void)setType:(NSString *)type;

@end
