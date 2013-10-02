//
//  ParticipantsViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 01.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchModel;

@interface ParticipantsViewController : UIViewController

@property (nonatomic, strong, readonly) SearchModel *search;

+ (ParticipantsViewController *)participantsWithSearch:(SearchModel *)search;

@end
