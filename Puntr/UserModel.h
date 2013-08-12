//
//  UserModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) NSURL *avatar;
@property (nonatomic, strong, readonly) NSNumber *topPosition;
@property (nonatomic, strong, readonly) NSNumber *rating;
@property (nonatomic, strong, readonly) NSNumber *subscriptionsCount;
@property (nonatomic, strong, readonly) NSNumber *subscribersCount;
@property (nonatomic, strong, readonly) NSNumber *badgesCount;
@property (nonatomic, strong, readonly) NSNumber *winCount;
@property (nonatomic, strong, readonly) NSNumber *lossCount;

@end
