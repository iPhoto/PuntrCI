//
//  UserDetailsModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 11.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef NS_ENUM(NSInteger, UserDetailsType)
{
    UserDetailsTypeSubscriptions = 2,
    UserDetailsTypeSubscribers,
    UserDetailsTypeAwards
};

@interface UserDetailsModel : NSObject

+ (UserDetailsModel *)detailsWithUser:(UserModel *)user type:(UserDetailsType)detailsType;

@property (nonatomic, strong) UserModel *user;
@property (nonatomic) UserDetailsType userDetailsType;

@end
