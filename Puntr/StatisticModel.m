//
//  StatisticModel.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/11/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "StatisticModel.h"

@interface StatisticModel ()

@property (nonatomic, strong) NSNumber *lossCount;
@property (nonatomic, strong) NSNumber *maximumGain;
@property (nonatomic, strong) NSNumber *stakesCount;
@property (nonatomic, strong) NSNumber *winCount;
@property (nonatomic, strong) NSNumber *lossMoney;
@property (nonatomic, strong) NSNumber *winMoney;

@end

@implementation StatisticModel

+ (StatisticModel *)statisticFromDictionary:(NSDictionary *)dictionary
{
    StatisticModel *statistic = [[self alloc] init];
    statistic.lossCount = dictionary[KeyLossCount];
    statistic.maximumGain = dictionary[KeyMaximumGain];
    statistic.stakesCount = dictionary[KeyStakesCount];
    statistic.winCount = dictionary[KeyWinCount];
    statistic.lossMoney = dictionary[KeyLossMoney];
    statistic.winMoney = dictionary[KeyWinMoney];
    return statistic;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.lossCount)
    {
        [parameters addEntriesFromDictionary:@{ KeyLossCount: self.lossCount }];
    }
    if (self.maximumGain)
    {
        [parameters addEntriesFromDictionary:@{ KeyMaximumGain: self.maximumGain }];
    }
    if (self.stakesCount)
    {
        [parameters addEntriesFromDictionary:@{ KeyStakesCount: self.stakesCount }];
    }
    if (self.winCount)
    {
        [parameters addEntriesFromDictionary:@{ KeyWinCount: self.winCount }];
    }
    if (self.lossMoney)
    {
        [parameters addEntriesFromDictionary:@{ KeyLossMoney: self.lossMoney }];
    }
    if (self.winMoney)
    {
        [parameters addEntriesFromDictionary:@{ KeyWinMoney: self.winMoney }];
    }
    return [parameters copy];
}

@end
