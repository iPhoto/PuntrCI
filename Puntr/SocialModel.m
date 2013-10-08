//
//  SocialModel.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/3/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SocialModel.h"

@implementation SocialModel

+ (SocialModel *)socialFromDictionary:(NSDictionary *)dictionary
{
    SocialModel *social = [[self alloc] init];
    social.facebook = dictionary[KeyFacebook];
    social.twitter = dictionary[KeyTwitter];
    social.vk = dictionary[KeyVKontakte];
    return social;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.facebook)
    {
        [parameters addEntriesFromDictionary:@{ KeyFacebook: self.facebook }];
    }
    if (self.twitter)
    {
        [parameters addEntriesFromDictionary:@{ KeyTwitter: self.twitter }];
    }
    if (self.vk)
    {
        [parameters addEntriesFromDictionary:@{ KeyVKontakte: self.vk }];
    }
    return [parameters copy];
}

@end
