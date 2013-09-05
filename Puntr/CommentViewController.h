//
//  CommentViewController.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/21/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventModel;

@interface CommentViewController : UIViewController

+ (CommentViewController *)commentWithEvent:(EventModel *)event;

@end
