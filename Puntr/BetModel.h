//
//  BetModel.h
//  Puntr
//
//  Created by Artem on 9/30/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventModel.h"
#import "MoneyModel.h"
#import "LineModel.h"
#import "UserModel.h"


@interface BetModel : NSObject

@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic) BOOL accepted;
@property (nonatomic, strong) NSNumber *winnerTag;
@property (nonatomic, strong) UserModel *creator;
@property (nonatomic, strong) UserModel *opponent;
@property (nonatomic, strong) EventModel *event;
@property (nonatomic, strong) LineModel *line;
@property (nonatomic, strong) MoneyModel *money;

@end
