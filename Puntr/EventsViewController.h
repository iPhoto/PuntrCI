//
//  EventsViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupModel, TournamentModel, SearchModel;

@interface EventsViewController : UIViewController

@property (nonatomic, strong, readonly) SearchModel *search;

+ (EventsViewController *)eventsForGroup:(GroupModel *)group tournament:(TournamentModel *)tournament search:(SearchModel *)search;

@end
