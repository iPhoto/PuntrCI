//
//  ProfileViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface ProfileViewController : UIViewController

- (id)initWithUser:(UserModel *)user;

@end
