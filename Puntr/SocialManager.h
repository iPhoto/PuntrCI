//
//  SocialManager.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/7/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKConnector.h"
#import "VKRequest.h"

typedef void (^SocialManagerSuccess)();

typedef enum {
    SocialNetworkTypeTwitter,
    SocialNetworkTypeFacebook,
    SocialNetworkTypeVkontakte
} SocialNetworkType;

@interface SocialManager : NSObject<VKConnectorDelegate>

+ (instancetype)sharedManager;

- (void)loginWithSocialNetworkOfType:(SocialNetworkType)socialNetworkType success:(SocialManagerSuccess)success;

@end
