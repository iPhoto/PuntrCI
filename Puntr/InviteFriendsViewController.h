//
//  InviteFriendsViewController.h
//  Puntr
//
//  Created by Momus on 03.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialManager.h"

@interface InviteFriendsViewController : UIViewController

+ (InviteFriendsViewController *)friendsForSocialNetworkType:(SocialNetworkType)socialType;

@end
