//
//  TournamentCell.m
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentCell.h"
#import "PuntrUtilities.h"

#define EDGE_SIZE   6.0f

@interface TournamentCell ()

@property (nonatomic, retain) TournamentModel *tournament;

@property (nonatomic, retain) UIImageView *tournamentIcon;

@property (nonatomic, retain) UIImageView *tournamentTopBackground;
@property (nonatomic, retain) UIImageView *tournamentBannerImage;

@property (nonatomic, retain) UILabel *tournamentNameLabel;
@property (nonatomic, retain) UILabel *tournamentStartTimeLabel;
@property (nonatomic, retain) UILabel *tournamentCreatedTimeLabel;

@end

@implementation TournamentCell

- (void)loadWithTournament:(TournamentModel *)tournament
{
    self.tournament = tournament;

    self.tournamentTopBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top"]];
    self.tournamentTopBackground.center = CGPointMake(self.frame.size.width / 2, self.tournamentTopBackground.frame.size.height / 2);
    [self addSubview:self.tournamentTopBackground];
    
    self.tournamentBannerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom"]];
    self.tournamentBannerImage.center = CGPointMake(self.frame.size.width / 2,CGRectGetMaxY(self.tournamentTopBackground.frame) + (self.tournamentBannerImage.frame.size.height / 2));
    [self addSubview:self.tournamentBannerImage];

    
    UIImage *iconImage = [UIImage imageNamed:@"IconLiga"];
    
    self.tournamentIcon = [[UIImageView alloc] initWithImage:iconImage];
    self.tournamentIcon.center = CGPointMake(iconImage.size.width / 2 + EDGE_SIZE + self.tournamentTopBackground.frame.origin.x, self.tournamentTopBackground.frame.size.height / 2);
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
    NSString *timeStr = @"";
    
    if ((hours != INT32_MAX) && (hours > 0)) {
        format = [NSString stringWithFormat:@"%i ч.", hours];
    }
    if ((minutes != INT32_MAX) && (minutes > 0)) {
        format = [format stringByAppendingFormat:@" %i м.", minutes];
    }
    
    if ([format isEqualToString:@""]) {
        timeStr = @"Турнир уже идет!";
    } else {
        timeStr = [NSString stringWithFormat:@"Через %@ начнется", format];
    }
    CGSize accesibleSize = CGSizeMake(self.frame.size.width - CGRectGetMaxX(self.tournamentIcon.frame), self.frame.size.height);
    CGSize textSize = [timeStr sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0f] constrainedToSize:accesibleSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.tournamentStartTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tournamentIcon.frame) + EDGE_SIZE, 4.0f, textSize.width, textSize.height)];
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

- (void)prepareForReuse {
    self.tournamentNameLabel.text = nil;
    self.tournamentStartTimeLabel.text = nil;
}

@end
