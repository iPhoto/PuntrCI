//
//  UserDetailsModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 11.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UserDetailsModel.h"

@implementation UserDetailsModel

+ (UserDetailsModel *)detailsWithUser:(UserModel *)user type:(UserDetailsType)detailsType
{
    UserDetailsModel *userDetailsModel = [[self alloc] init];
    userDetailsModel.user = user;
    userDetailsModel.userDetailsType = detailsType;
    return userDetailsModel;
}

@end
