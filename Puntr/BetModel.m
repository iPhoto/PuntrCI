//
//  BetModel.m
//  Puntr
//
//  Created by Artem on 9/30/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "BetModel.h"

@implementation BetModel

+ (BetModel *)betWithEvent:(EventModel *)event line:(LineModel *)line opponent:(UserModel *)opponent money:(MoneyModel *)money
{
    BetModel *bet = [[self alloc] init];
    bet.event = event;
    bet.line = line;
    bet.opponent = opponent;
    bet.money = money;
    return bet;
}

@end
