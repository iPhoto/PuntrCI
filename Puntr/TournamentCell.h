//
//  TournamentCell.h
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentModel.h"


@interface TournamentCell : UICollectionViewCell

- (void)loadWithTournament:(TournamentModel *)tournament;

@end