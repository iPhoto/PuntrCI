//
//  TNIConstants.h
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNIConstants : NSObject

#pragma mark - Services

FOUNDATION_EXPORT NSString *const TestFlightApplicationToken;

#pragma mark - API

FOUNDATION_EXPORT NSString *const APIScheme;
FOUNDATION_EXPORT NSString *const APIHost;

FOUNDATION_EXPORT NSString *const DevelopmentAPIScheme;
FOUNDATION_EXPORT NSString *const DevelopmentAPIHost;

FOUNDATION_EXPORT NSString *const APIAuthorization;
FOUNDATION_EXPORT NSString *const APIUsers;
FOUNDATION_EXPORT NSString *const APIEvents;

#pragma mark - Parameters

FOUNDATION_EXPORT NSString *const KeyAvatar;
FOUNDATION_EXPORT NSString *const KeyEmail;
FOUNDATION_EXPORT NSString *const KeyFirstName;
FOUNDATION_EXPORT NSString *const KeyLastName;
FOUNDATION_EXPORT NSString *const KeyLogin;
FOUNDATION_EXPORT NSString *const KeyNickname;
FOUNDATION_EXPORT NSString *const KeyPassword;
FOUNDATION_EXPORT NSString *const KeySID;
FOUNDATION_EXPORT NSString *const KeyTag;

@end
