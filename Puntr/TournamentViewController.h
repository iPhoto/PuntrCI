//
//  TournamentViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchModel, TournamentModel;

@interface TournamentViewController : UIViewController

@property (nonatomic, strong, readonly) TournamentModel *tournament;
@property (nonatomic, strong, readonly) SearchModel *search;

+ (TournamentViewController *)controllerForTournament:(TournamentModel *)tournament search:(SearchModel *)search;

@end
