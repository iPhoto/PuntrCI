//
//  TournamentCell.m
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentCell.h"
#import "PuntrUtilities.h"

#define EDGE_SIZE   4.0f

@interface TournamentCell ()

@property (nonatomic, retain) TournamentModel *tournament;

@property (nonatomic, retain) UIImageView *tournamentIcon;
@property (nonatomic, retain) UILabel *tournamentNameLabel;
@property (nonatomic, retain) UILabel *tournamentStartTimeLabel;
@property (nonatomic, retain) UILabel *tournamentCreatedTimeLabel;

@end

@implementation TournamentCell

- (void)loadWithTournament:(TournamentModel *)tournament
{
    self.tournament = tournament;
    
    UIImage *iconImage = [UIImage imageNamed:@"IconLiga"];
    
    self.tournamentIcon = [[UIImageView alloc] initWithImage:iconImage];
    self.tournamentIcon.center = CGPointMake(iconImage.size.width / 2 + EDGE_SIZE, self.frame.size.height / 2);
    [self addSubview:self.tournamentIcon];
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = self.tournament.startTime;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];

    NSInteger months = INT32_MAX;
    NSInteger days = INT32_MAX;
    NSInteger hours = INT32_MAX;
    NSInteger minutes = INT32_MAX;

    months = [components month];
    days = [components day];
    hours = [components hour];
    minutes = [components minute];
    
    NSString *format = @"";
    if (hours != INT32_MAX) {
        format = [NSString stringWithFormat:@"%i ч.", hours];
    }
    if (minutes != INT32_MAX) {
        format = [format stringByAppendingFormat:@" %i м.", minutes];
    }

    NSString *timeStr = [NSString stringWithFormat:@"Через %@ начнется", format];
    
    CGSize accesibleSize = CGSizeMake(self.frame.size.width - CGRectGetMaxX(self.tournamentIcon.frame), self.frame.size.height);
    CGSize textSize = [timeStr sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0f] constrainedToSize:accesibleSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.tournamentStartTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tournamentIcon.frame) + EDGE_SIZE, 2.0f, textSize.width, textSize.height)];
    self.tournamentStartTimeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
    self.tournamentStartTimeLabel.textColor = [UIColor whiteColor];
    self.tournamentStartTimeLabel.backgroundColor = [UIColor clearColor];
    self.tournamentStartTimeLabel.shadowColor = [UIColor blackColor];
    self.tournamentStartTimeLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.tournamentStartTimeLabel.text = timeStr;
    [self addSubview:self.tournamentStartTimeLabel];
    
    
    textSize = [self.tournament.title sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0f] constrainedToSize:accesibleSize lineBreakMode:NSLineBreakByWordWrapping];
    self.tournamentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tournamentIcon.frame) + EDGE_SIZE, 2.0f + CGRectGetMaxY(self.tournamentStartTimeLabel.frame), textSize.width, textSize.height)];
    self.tournamentNameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
    self.tournamentNameLabel.textColor = [UIColor whiteColor];
    self.tournamentNameLabel.backgroundColor = [UIColor clearColor];
    self.tournamentNameLabel.shadowColor = [UIColor blackColor];
    self.tournamentNameLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.tournamentNameLabel.text = self.tournament.title;
    [self addSubview:self.tournamentNameLabel];
}

@end
