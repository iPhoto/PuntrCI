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

@class SocialManager;

@protocol SocialManagerDelegate

- (void) socialManagerDelegateMethod: (SocialManager *) sender;

@end

@interface SocialManager : NSObject<VKConnectorDelegate>

+ (SocialManager*)sharedManager;

- (void)loginWithSocialNetworkOfType:(SocialNetworkType)socialNetworkType success:(SocialManagerSuccess)success;

@property (nonatomic, weak) id <SocialManagerDelegate> delegate;

@end
