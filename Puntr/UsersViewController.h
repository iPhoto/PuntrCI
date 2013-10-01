//
//  UsersViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 01.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchModel;

@interface UsersViewController : UIViewController

@property (nonatomic, strong, readonly) SearchModel *search;

+ (UsersViewController *)usersWithSearch:(SearchModel *)search;

@end
