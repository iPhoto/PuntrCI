//
//  StakeModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 12.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "StakeModel.h"

@interface StakeModel ()

@property (nonatomic, strong) EventModel *event;
@property (nonatomic, strong) LineModel *line;
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) CoefficientModel *coefficient;
@property (nonatomic, strong) MoneyModel *money;

@end

@implementation StakeModel

+ (StakeModel *)stakeWithEvent:(EventModel *)event Line:(LineModel *)line components:(NSArray *)components coefficient:(CoefficientModel *)coefficient money:(MoneyModel *)money {
    
    StakeModel *stake = [[StakeModel alloc] init];
    
    stake.event = event;
    stake.line = line;
    stake.components = components;
    stake.coefficient = coefficient;
    stake.money = money;
    
    return stake;
    
}

@end
