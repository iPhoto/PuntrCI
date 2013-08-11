//
//  TournamentCell.m
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentCell.h"
#import "PuntrUtilities.h"

@interface TournamentCell ()

@property (nonatomic, retain) TournamentModel *tournament;

@property (nonatomic, retain) UIImageView   *tournamentIcon;
@property (nonatomic, retain) UILabel       *tournamentNameLabel;
@property (nonatomic, retain) UILabel       *tournamentStartTimeLabel;
@property (nonatomic, retain) UILabel       *tournamentCreatedTimeLabel;

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
    
    UIImage *iconImage = [UIImage imageNamed:@"IconLiga"];
    
    self.tournamentIcon = [[UIImageView alloc] initWithImage:iconImage];
    self.tournamentIcon.center = CGPointMake(iconImage.size.width / 2, self.frame.size.height / 2);
    [self addSubview:self.tournamentIcon];
    
    NSString *timeStr = [PuntrUtilities formattedDate:self.tournament.startTime];
    timeStr = [NSString stringWithFormat:@"%@ начнется", timeStr];
    
    CGSize accesibleSize = CGSizeMake(self.frame.size.width - self.tournamentIcon.frame.size.width - self.tournamentIcon.frame.origin.x, self.frame.size.height);
    CGSize textSize = [timeStr sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f] constrainedToSize:accesibleSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.tournamentStartTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tournamentIcon.frame.origin.x + self.tournamentIcon.frame.size.width, 2.0f, textSize.width, textSize.height)];
    self.tournamentStartTimeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.tournamentStartTimeLabel.textColor = [UIColor whiteColor];
    self.tournamentStartTimeLabel.backgroundColor = [UIColor clearColor];
    self.tournamentStartTimeLabel.shadowColor = [UIColor blackColor];
    self.tournamentStartTimeLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.tournamentStartTimeLabel.text = timeStr;
    [self addSubview:self.tournamentStartTimeLabel];
    

    self.tournamentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tournamentIcon.frame.origin.x + self.tournamentIcon.frame.size.width, 2.0f + self.tournamentStartTimeLabel.frame.origin.y + self.tournamentStartTimeLabel.frame.size.height, self.frame.size.width - (self.tournamentIcon.frame.origin.x + self.tournamentIcon.frame.size.width), textSize.height)];
    self.tournamentNameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.tournamentNameLabel.textColor = [UIColor whiteColor];
    self.tournamentNameLabel.backgroundColor = [UIColor clearColor];
    self.tournamentNameLabel.shadowColor = [UIColor blackColor];
    self.tournamentNameLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.tournamentNameLabel.text = self.tournament.title;
    [self addSubview:self.tournamentNameLabel];
    
    
    timeStr = [PuntrUtilities formattedDate:self.tournament.endTime];
    timeStr = [NSString stringWithFormat:@"%@ назад", timeStr];
    
    self.tournamentCreatedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tournamentIcon.frame.origin.x + self.tournamentIcon.frame.size.width, 2.0f + self.tournamentStartTimeLabel.frame.origin.y + self.tournamentStartTimeLabel.frame.size.height, self.frame.size.width - (self.tournamentIcon.frame.origin.x + self.tournamentIcon.frame.size.width), textSize.height)];
    self.tournamentCreatedTimeLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
    self.tournamentCreatedTimeLabel.textColor = [UIColor whiteColor];
    self.tournamentCreatedTimeLabel.backgroundColor = [UIColor clearColor];
    self.tournamentCreatedTimeLabel.shadowColor = [UIColor blackColor];
    self.tournamentCreatedTimeLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.tournamentCreatedTimeLabel.text = self.tournament.title;
    [self addSubview:self.tournamentCreatedTimeLabel];
}

@end
