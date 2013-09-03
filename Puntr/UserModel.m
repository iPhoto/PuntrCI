//
//  UserModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UserModel.h"
#import "SocialModel.h"

@interface UserModel ()

@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, strong) NSNumber *topPosition;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *subscriptionsCount;
@property (nonatomic, strong) NSNumber *subscribersCount;
@property (nonatomic, strong) NSNumber *badgesCount;
@property (nonatomic, strong) NSNumber *winCount;
@property (nonatomic, strong) NSNumber *lossCount;
@property (nonatomic, strong) SocialModel *socials;

@end

@implementation UserModel

- (NSDictionary *)parameters
{
    if (self.tag)
    {
        return @{ KeyTag: self.tag };
    }
    else
    {
        return @{};
    }
}

- (NSDictionary *)wrappedParameters
{
    return @{KeyUser: self.parameters};
}

- (NSURL *)avatarWithSize:(CGSize)size
{
    NSString *sizeComponent = [NSString stringWithFormat:@"%ix%i", (NSInteger)size.width, (NSInteger)size.height];
    return [self.avatar URLByAppendingPathComponent:sizeComponent];
}

- (BOOL)isEqualToUser:(UserModel *)user
{
    if ([self.tag isEqualToNumber:user.tag])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    UserModel *user = [[UserModel allocWithZone:zone] init];
    user.tag = self.tag;
    user.email = self.email;
    user.password = self.password;
    user.firstName = self.firstName;
    user.lastName = self.lastName;
    user.username = self.username;
    user.avatar = self.avatar;
    user.avatarData = self.avatarData;
    user.subscribed = self.subscribed;
    user.topPosition = self.topPosition;
    user.rating = self.rating;
    user.subscriptionsCount = self.subscriptionsCount;
    user.subscribersCount = self.subscribersCount;
    user.badgesCount = self.badgesCount;
    user.winCount = self.winCount;
    user.lossCount = self.lossCount;
    
    return user;
}

@end
