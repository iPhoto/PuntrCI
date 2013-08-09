//
//  EventCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventCell.h"
#import "EventModel.h"
#import <QuartzCore/QuartzCore.h>
#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import "ObjectManager.h"
#import "NotificationManager.h"

@interface EventCell ()

@property (nonatomic, strong) EventModel *event;

@property (nonatomic, strong) UILabel *labelCategory;
@property (nonatomic, strong) UILabel *labelParticipants;
@property (nonatomic, strong) UIImageView *imageViewDelimiter;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelStakes;

@end

@implementation EventCell

- (void)loadWithEvent:(EventModel *)event {
    
    self.event = event;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.labelCategory = [[UILabel alloc] init];
    self.labelCategory.frame = CGRectMake(23.0f, 6.5f, 200.0f, 10.4f);
    self.labelCategory.font = [UIFont fontWithName:@"ArialMT" size:10.4f];
    self.labelCategory.backgroundColor = [UIColor clearColor];
    self.labelCategory.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelCategory.text = [event.category.title capitalizedString];
    [self addSubview:self.labelCategory];
    
    self.labelParticipants = [[UILabel alloc] init];
    self.labelParticipants.frame = CGRectMake(8.0f, 22.0f, 230.0f, 12.5f);
    self.labelParticipants.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.5f];
    self.labelParticipants.backgroundColor = [UIColor clearColor];
    self.labelParticipants.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    NSString *participants = @"";
    NSUInteger counter = 0;
    for (ParticipantModel *participant in event.participants) {
        if (counter == 0) {
            participants = participant.title;
        } else {
            participants = [NSString stringWithFormat:@"%@ — %@", participants, participant.title];
        }
        counter++;
    }
    self.labelParticipants.text = participants;
    [self addSubview:self.labelParticipants];
    
    self.buttonStake = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonStake.frame = CGRectMake(237.0f, 5.0f, 63.0f, 31.0f);
    self.buttonStake.adjustsImageWhenHighlighted = NO;
    [self.buttonStake setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    [self.buttonStake addTarget:self action:@selector(stakeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonStake];
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 1.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self addSubview:self.imageViewDelimiter];
    
    self.labelTime = [[UILabel alloc] init];
    self.labelTime.frame = CGRectMake(8.0f, 47.0f, self.frame.size.width, 10.4f);
    self.labelTime.font = [UIFont fontWithName:@"ArialMT" size:10.4f];
    self.labelTime.backgroundColor = [UIColor clearColor];
    self.labelTime.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    self.labelTime.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:event.startTime];
    [self addSubview:self.labelTime];
    
    self.labelStakes = [[UILabel alloc] init];
    self.labelStakes.frame = CGRectMake(8.0f, 47.0f, self.frame.size.width - 8.0f * 2.0f, 10.4f);
    self.labelStakes.font = [UIFont fontWithName:@"ArialMT" size:10.4f];
    self.labelStakes.backgroundColor = [UIColor clearColor];
    self.labelStakes.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelStakes.text = [NSString stringWithFormat:@"%i ставок", event.stakesCount.integerValue];
    self.labelStakes.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelStakes];
    
    self.layer.cornerRadius = 3.75f;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}
/*
- (void)stakeButtonTouched {
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[StakeViewController alloc] initWithEvent:self.event]] animated:YES completion:^{
        
    }];
}
*/
- (void)prepareForReuse {
    [self.labelCategory removeFromSuperview];
    self.labelCategory = nil;
    [self.labelParticipants removeFromSuperview];
    self.labelParticipants = nil;
    [self.buttonStake removeFromSuperview];
    self.buttonStake = nil;
    [self.imageViewDelimiter removeFromSuperview];
    self.imageViewDelimiter = nil;
    [self.labelTime removeFromSuperview];
    self.labelTime = nil;
    [self.labelStakes removeFromSuperview];
    self.labelStakes = nil;
    
    self.event = nil;
    
    
}

@end
