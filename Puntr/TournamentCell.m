//
//  TournamentCell.m
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentCell.h"

@interface TournamentCell ()

@property (nonatomic, retain) TournamentModel *tournament;

@end

@implementation TournamentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)loadWithTournament:(TournamentModel *)tournament {
    self.tournament = tournament;
    
    
}

@end
