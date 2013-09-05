//
//  TournamentViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TournamentModel;

@interface TournamentViewController : UIViewController

+ (TournamentViewController *)controllerForTournament:(TournamentModel *)tournament;

@end
