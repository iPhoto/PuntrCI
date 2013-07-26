//
//  EventViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 10.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EventModel.h"
#import "ObjectManager.h"
#import "NotificationManager.h"
#import "StakeViewController.h"
#import "ParticipantViewController.h"

@interface EventViewController ()

@property (nonatomic, strong, readonly) EventModel *event;

@property (nonatomic, strong) UIImageView *imageViewDelimiter;

@property (nonatomic, strong) UILabel *labelParticipantFirst;
@property (nonatomic, strong) UILabel *labelParticipantSecond;
@property (nonatomic, strong) UILabel *labelStatus;

@property (nonatomic, strong) UIButton *buttonParticipantFirst;
@property (nonatomic, strong) UIButton *buttonParticipantSecond;
@property (nonatomic, strong) UIButton *buttonSubscribe;
@property (nonatomic, strong) UIButton *buttonStake;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation EventViewController

- (id)initWithEvent:(EventModel *)event {
    self = [super init];
    if (self) {
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Событие";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGFloat screenWidth = 320.0f;
    CGFloat coverMargin = 8.0f;
    CGFloat participantsHeight = 70.0f;
    
    UIView *backgroundCover = [[UIView alloc] initWithFrame:CGRectMake(coverMargin, coverMargin, screenWidth - coverMargin * 2.0f, participantsHeight * 2.0f)];
    backgroundCover.backgroundColor = [UIColor whiteColor];
    backgroundCover.layer.cornerRadius = 3.75f;
    backgroundCover.layer.masksToBounds = YES;
    [self.view addSubview:backgroundCover];
    
    UIFont *fontParticipants = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    
    CGSize participantSize = CGSizeMake((screenWidth - 2.0f * coverMargin) / 2.0f, participantsHeight);
    CGFloat labelPadding = 20.0f;
    /*
    self.labelParticipantFirst = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + labelPadding, coverMargin, participantSize.width - labelPadding * 2.0f, participantSize.height)];
    self.labelParticipantFirst.font = fontParticipants;
    self.labelParticipantFirst.backgroundColor = [UIColor clearColor];
    self.labelParticipantFirst.textAlignment = NSTextAlignmentCenter;
    self.labelParticipantFirst.numberOfLines = 0;
    self.labelParticipantFirst.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelParticipantFirst.text = [(ParticipantModel *)self.event.participants[0] title];
    [self.view addSubview:self.labelParticipantFirst];
    */
    self.buttonParticipantFirst = [[UIButton alloc] initWithFrame:CGRectMake(2*coverMargin, coverMargin + 13, 128, 44)];
    [self.buttonParticipantFirst setBackgroundImage:[[UIImage imageNamed:@"ButtonGray"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)] forState:UIControlStateNormal];
    self.buttonParticipantFirst.titleLabel.font = fontParticipants;
    //self.buttonParticipantFirst.titleLabel.backgroundColor = [UIColor clearColor];
    self.buttonParticipantFirst.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonParticipantFirst.titleLabel.numberOfLines = 0;
    [self.buttonParticipantFirst setTitleColor:[UIColor colorWithWhite:0.200 alpha:1.000] forState:UIControlStateNormal];
    [self.buttonParticipantFirst setTitle:[(ParticipantModel *)self.event.participants[0] title] forState:UIControlStateNormal];
    [self.buttonParticipantFirst addTarget:self action:@selector(showParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonParticipantFirst];
    
    self.labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + participantSize.width - labelPadding, coverMargin, labelPadding * 2.0f, participantSize.height)];
    self.labelStatus.font = fontParticipants;
    self.labelStatus.backgroundColor = [UIColor clearColor];
    self.labelStatus.textAlignment = NSTextAlignmentCenter;
    self.labelStatus.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelStatus.text = self.event.status ? self.event.status : @"—";
    [self.view addSubview:self.labelStatus];
    /*
    self.labelParticipantSecond = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + labelPadding + participantSize.width, coverMargin, participantSize.width - labelPadding * 2.0f, participantSize.height)];
    self.labelParticipantSecond.font = fontParticipants;
    self.labelParticipantSecond.backgroundColor = [UIColor clearColor];
    self.labelParticipantSecond.textAlignment = NSTextAlignmentCenter;
    self.labelParticipantSecond.numberOfLines = 0;
    self.labelParticipantSecond.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelParticipantSecond.text = [(ParticipantModel *)self.event.participants[1] title];
    [self.view addSubview:self.labelParticipantSecond];
    */
    self.buttonParticipantSecond = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (2*coverMargin + 128), coverMargin + 13, 128, 44)];
    [self.buttonParticipantSecond setBackgroundImage:[[UIImage imageNamed:@"ButtonGray"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)] forState:UIControlStateNormal];
    self.buttonParticipantSecond.titleLabel.font = fontParticipants;
    self.buttonParticipantSecond.titleLabel.backgroundColor = [UIColor clearColor];
    self.buttonParticipantSecond.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonParticipantSecond.titleLabel.numberOfLines = 0;
    [self.buttonParticipantSecond setTitleColor:[UIColor colorWithWhite:0.200 alpha:1.000] forState:UIControlStateNormal];
    [self.buttonParticipantSecond setTitle:[(ParticipantModel *)self.event.participants[1] title] forState:UIControlStateNormal];
    [self.buttonParticipantSecond addTarget:self action:@selector(showParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonParticipantSecond];
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(coverMargin, coverMargin + participantSize.height, screenWidth - coverMargin * 2.0f, 1.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewDelimiter];
    
    self.buttonSubscribe = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonSubscribe.frame = CGRectMake(coverMargin * 2.0f, coverMargin + participantSize.height + 15.0f, (screenWidth - coverMargin * 5.0f) / 2.0f, 40.0f);
    self.buttonSubscribe.adjustsImageWhenHighlighted = NO;
    [self.buttonSubscribe setTitle:@"Подписаться" forState:UIControlStateNormal];
    self.buttonSubscribe.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSubscribe];
    
    self.buttonStake = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonStake.frame = CGRectMake(coverMargin * 3.0f + (screenWidth - coverMargin * 5.0f) / 2.0f, coverMargin + participantSize.height + 15.0f, (screenWidth - coverMargin * 5.0f) / 2.0f, 40.0f);
    self.buttonStake.adjustsImageWhenHighlighted = NO;
    [self.buttonStake setTitle:@"Ставить" forState:UIControlStateNormal];
    self.buttonStake.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonStake.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreen"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.buttonStake addTarget:self action:@selector(stakeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonStake];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Комментарии", @"Ставки"]];
    self.segmentedControl.frame = CGRectMake(15.0f, coverMargin + participantsHeight * 2.0f + 25.0f, 290.0f, 31.0f);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor blackColor];
    [self.view addSubview:self.segmentedControl];
    dispatch_async(dispatch_get_main_queue(),^{
        self.segmentedControl.selectedSegmentIndex = 1;
    });
}

- (void)stakeButtonTouched {
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[StakeViewController alloc] initWithEvent:self.event]] animated:YES completion:^{
        
    }];
}

- (void)showParticipant:(id)sender {
    int i;
    if((UIButton *)sender == self.buttonParticipantFirst)
    {
        i = 0;
    }else{
        i = 1;
    }
    [self.navigationController pushViewController:[[ParticipantViewController alloc] initWithParticipant:self.event.participants[i]] animated:YES];
}

@end
