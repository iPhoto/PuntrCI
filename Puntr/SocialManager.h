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
typedef void (^SocialManagerFailure)();

typedef NS_ENUM(NSInteger, SocialNetworkType)
{
    SocialNetworkTypeTwitter,
    SocialNetworkTypeFacebook,
    SocialNetworkTypeVkontakte,
    SocialNetworkTypeNone
};

@class SocialManager;

@protocol SocialManagerDelegate

- (void)socialManager:(SocialManager *)sender twitterAccounts:(NSArray *)array;

@end

@interface SocialManager : NSObject<VKConnectorDelegate>

+ (SocialManager *)sharedManager;

- (void)loginWithSocialNetworkOfType:(SocialNetworkType)socialNetworkType success:(SocialManagerSuccess)success failure:(SocialManagerFailure)failure;

- (void)loginTwWithUser:(NSInteger)index;

@property (nonatomic, weak) id <SocialManagerDelegate> delegate;

@end
