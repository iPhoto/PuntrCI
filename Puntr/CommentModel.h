//
//  CommentModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventModel.h"
#import "UserModel.h"

@interface CommentModel : NSObject

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) UserModel *user;
@property (nonatomic, strong, readonly) EventModel *event;

@end
