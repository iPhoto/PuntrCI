//
//  StakeViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 16.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventModel;

@interface StakeViewController : UIViewController

+ (StakeViewController *)stakeWithEvent:(EventModel *)event;

@end
