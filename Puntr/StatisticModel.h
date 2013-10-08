//
//  StatisticModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 9/11/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *lossCount;
@property (nonatomic, strong, readonly) NSNumber *maximumGain;
@property (nonatomic, strong, readonly) NSNumber *stakesCount;
@property (nonatomic, strong, readonly) NSNumber *winCount;
@property (nonatomic, strong, readonly) NSNumber *lossMoney;
@property (nonatomic, strong, readonly) NSNumber *winMoney;

+ (StatisticModel *)statisticFromDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)parameters;

@end
