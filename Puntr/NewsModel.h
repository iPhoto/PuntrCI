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
@property (nonatomic, strong, readonly) StakeModel *stake;
@property (nonatomic, strong, readonly) CommentModel *comment;
@property (nonatomic, strong, readonly) FeedModel *feed;

@end
