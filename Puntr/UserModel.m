//
//  UserModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UserModel.h"

@interface UserModel ()

@property (nonatomic, strong) NSNumber *topPosition;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *subscriptionsCount;
@property (nonatomic, strong) NSNumber *subscribersCount;
@property (nonatomic, strong) NSNumber *badgesCount;
@property (nonatomic, strong) NSNumber *winCount;
@property (nonatomic, strong) NSNumber *lossCount;

@end

@implementation UserModel

+ (UserModel *)userFromDictionary:(NSDictionary *)dictionary
{
    UserModel *user = [[self alloc] init];
    user.tag = dictionary[KeyTag];
    user.email = dictionary[KeyEmail];
    user.password = dictionary[KeyPassword];
    user.firstName = dictionary[KeyFirstName];
    user.lastName = dictionary[KeyLastName];
    user.username = dictionary[KeyUsername];
    user.avatar = [NSURL URLWithString:(NSString *)dictionary[KeyAvatar]];
    user.subscribed = dictionary[KeySubscribed];
    user.topPosition = dictionary[KeyTopPosition];
    user.rating = dictionary[KeyRating];
    user.subscriptionsCount = dictionary[KeySubscriptionsCount];
    user.subscribersCount = dictionary[KeySubscribersCount];
    user.badgesCount = dictionary[KeyBadgesCount];
    user.winCount = dictionary[KeyWinCount];
    user.lossCount = dictionary[KeyLossCount];
    SocialModel *socials = [SocialModel socialFromDictionary:dictionary[KeySocials]];
    user.socials = socials;
    StatisticModel *statistics = [StatisticModel statisticFromDictionary:dictionary[KeyStatistics]];
    user.statistics = statistics;
    return user;
}

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

- (NSDictionary *)saveParameters
{
    NSMutableDictionary *saveParameters = [NSMutableDictionary dictionary];
    if (self.tag)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyTag: self.tag }];
    }
    if (self.email)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyEmail: self.email }];
    }
    if (self.password)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyPassword: self.password }];
    }
    if (self.firstName)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyFirstName: self.firstName }];
    }
    if (self.lastName)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyLastName: self.lastName }];
    }
    if (self.username)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyUsername: self.username }];
    }
    if (self.avatar)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyAvatar: self.avatar.absoluteString }];
    }
    if (self.subscribed)
    {
        [saveParameters addEntriesFromDictionary:@{ KeySubscribed: self.subscribed }];
    }
    if (self.topPosition)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyTopPosition: self.topPosition }];
    }
    if (self.rating)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyRating: self.rating }];
    }
    if (self.subscriptionsCount)
    {
        [saveParameters addEntriesFromDictionary:@{ KeySubscriptionsCount: self.subscriptionsCount }];
    }
    if (self.subscribersCount)
    {
        [saveParameters addEntriesFromDictionary:@{ KeySubscribersCount: self.subscribersCount }];
    }
    if (self.badgesCount)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyBadgesCount: self.badgesCount }];
    }
    if (self.winCount)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyWinCount: self.winCount }];
    }
    if (self.lossCount)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyLossCount: self.lossCount }];
    }
    if (self.socials)
    {
        [saveParameters addEntriesFromDictionary:@{ KeySocials: self.socials.parameters }];
    }
    if (self.statistics)
    {
        [saveParameters addEntriesFromDictionary:@{ KeyStatistics: self.statistics.parameters }];
    }
    return [saveParameters copy];
}

- (NSURL *)avatarWithSize:(CGSize)size
{
    NSString *sizeComponent = [NSString stringWithFormat:@"%ix%i", (NSInteger)size.width, (NSInteger)size.height];
    return [self.avatar URLByAppendingPathComponent:sizeComponent];
}

- (BOOL)isEqualToUser:(UserModel *)user
{
    if (user.tag && [self.tag isEqualToNumber:user.tag])
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
