//
//  SubscriptionModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventModel.h"
#import "ParticipantModel.h"
#import "TournamentModel.h"
#import "UserModel.h"
#import <Foundation/Foundation.h>


@interface SubscriptionModel : NSObject

@property (nonatomic, strong) EventModel *event;
@property (nonatomic, strong) ParticipantModel *participant;
@property (nonatomic, strong) TournamentModel *tournament;
@property (nonatomic, strong) UserModel *user;

@end
