//
//  TournamentsViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupModel, SearchModel;

@interface TournamentsViewController : UIViewController

@property (nonatomic, strong, readonly) SearchModel *search;

+ (TournamentsViewController *)tournamentsForGroup:(GroupModel *)group search:(SearchModel *)search;

@end
