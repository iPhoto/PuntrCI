//
//  SubscribersViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 09.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface SubscribersViewController : UIViewController

+ (SubscribersViewController *)subscribersForUser:(UserModel *)user;

@end
