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

- (void)prepareForTransmission {
    self.event = nil;
}

+ (StakeModel *)stakeWithEvent:(EventModel *)event Line:(LineModel *)line components:(NSArray *)components {
    
    StakeModel *stake = [[StakeModel alloc] init];
    
    stake.event = event;
    stake.line = line;
    stake.components = components;
    
    return stake;
}

- (NSDictionary *)parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.line) {
        [parameters setObject:self.line.parameters forKey:KeyLine];
    }
    if (self.components) {
        NSMutableArray *components = [NSMutableArray arrayWithCapacity:self.components.count];
        for (ComponentModel *component in self.components) {
            [components addObject:component.parameters];
        }
        [parameters setObject:[components copy] forKey:KeyComponents];
    }
    return [parameters copy];
}

@end
