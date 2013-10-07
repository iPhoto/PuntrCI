//
//  AuthorizationModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AuthorizationModel.h"

@implementation AuthorizationModel

+ (AuthorizationModel *)authorizationWithDictionary:(NSDictionary *)dictionary
{
    AuthorizationModel *authorization = [[self alloc] init];
    authorization.sid = dictionary[KeySID];
    authorization.secret = dictionary[KeySecret];
    authorization.pushToken = dictionary[KeyPushToken];
    authorization.expires = dictionary[KeyExpires];
    return authorization;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.sid)
    {
        [parameters setObject:self.sid forKey:KeySID];
    }
    if (self.secret)
    {
        [parameters setObject:self.secret forKey:KeySecret];
    }
    if (self.pushToken)
    {
        [parameters setObject:self.pushToken forKey:KeyPushToken];
    }
    return [parameters copy];
}

- (NSDictionary *)wrappedParameters
{
    return @{ KeyAuthorization: [self parameters] };
}

- (NSDictionary *)saveParameters
{
    NSMutableDictionary *saveParameters = [NSMutableDictionary dictionaryWithDictionary:[self parameters]];
    if (self.expires)
    {
        [saveParameters setObject:self.expires forKey:KeyExpires];
    }
    return [saveParameters copy];
}

@end
