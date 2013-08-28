//
//  ActivityModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CommentModel.h"
#import "EventModel.h"
#import "ParticipantModel.h"
#import "StakeModel.h"
#import "TournamentModel.h"
#import "UserModel.h"
#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) StakeModel *stake;
@property (nonatomic, strong, readonly) CommentModel *comment;
@property (nonatomic, strong, readonly) EventModel *event;
@property (nonatomic, strong, readonly) ParticipantModel *participant;
@property (nonatomic, strong, readonly) TournamentModel *tournament;
@property (nonatomic, strong, readonly) UserModel *user;

@end
