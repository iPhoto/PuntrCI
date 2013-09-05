//
//  EventsViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupModel;

@interface EventsViewController : UIViewController

+ (EventsViewController *)eventsForGroup:(GroupModel *)group;

@end