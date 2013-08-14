//
//  MoneyModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "MoneyModel.h"

@interface MoneyModel ()

@property (nonatomic, strong) NSNumber *amount;

@end

@implementation MoneyModel

+ (MoneyModel *)moneyWithAmount:(NSNumber *)amount
{
    MoneyModel *money = [[MoneyModel alloc] init];
    money.amount = amount;
    return money;
}

@end
