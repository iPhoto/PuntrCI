//
//  NewsModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "FeedModel.h"
#import "StakeModel.h"

@interface NewsModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) StakeModel *stake;
@property (nonatomic, strong, readonly) CommentModel *comment;
@property (nonatomic, strong, readonly) FeedModel *feed;
@property (nonatomic, strong, readonly) EventModel *event;
@property (nonatomic, strong, readonly) TournamentModel *tournament;

@end
