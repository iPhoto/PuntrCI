//
//  ParticipantViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 7/26/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "NotificationManager.h"
#import "ObjectManager.h"
#import "ParticipantViewController.h"
#import "ParticipantModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIViewController+Puntr.h"

static const CGFloat TNSpacingItemSmall = 8.0f;
static const CGFloat TNSpacingItem = 12.0f;

@interface ParticipantViewController ()

@property (nonatomic, strong) UILabel *labelFollowers;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imageViewLogo;
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UIButton *buttonSubscribe;
@property (nonatomic, strong) ParticipantModel *participant;

@end

@implementation ParticipantViewController

- (id)initWithParticipant:(ParticipantModel *)participant
{
    self = [super init];
    if (self)
    {
        self.participant = participant;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Команда";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(TNSpacingItemSmall, TNSpacingItemSmall, CGRectGetWidth(self.frame) - TNSpacingItemSmall * 2.0f, 76)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    whiteView.layer.cornerRadius = 3.75;
    whiteView.layer.masksToBounds = YES;
    
    self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(78, 10, 225, 15)];
    [self.labelTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    [self.labelTitle setBackgroundColor:[UIColor clearColor]];
    [self.labelTitle setText:self.participant.title];
    [whiteView addSubview:self.labelTitle];
    
    self.imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(78, 55, 10, 9)];
    [self.imageViewIcon setImage:[UIImage imageNamed:@"IconUser"]];
    [whiteView addSubview:self.imageViewIcon];
    
    self.labelFollowers = [[UILabel alloc] initWithFrame:CGRectMake(95, 53, 110, 15)];
    [self.labelFollowers setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    [self.labelFollowers setBackgroundColor:[UIColor clearColor]];
    [self.labelFollowers setText:[NSString stringWithFormat:@"Болельщиков: %@", self.participant.subscribersCount.stringValue]];
    [whiteView addSubview:self.labelFollowers];
    
    self.imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    [whiteView addSubview:self.imageViewLogo];
    [self.imageViewLogo setImageWithURL:self.participant.logo];
    
    const CGFloat TNHeightButtonSubscribe = 31.0f;
    const CGFloat TNWidthButtonSubscribe = 94.0f;
    
    self.buttonSubscribe = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                      CGRectGetWidth(whiteView.frame) - TNSpacingItemSmall - TNWidthButtonSubscribe,
                                                                      CGRectGetMaxY(self.labelFollowers.frame) - TNHeightButtonSubscribe,
                                                                      TNWidthButtonSubscribe,
                                                                      TNHeightButtonSubscribe
                                                                      )];
    
    [self.buttonSubscribe.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12.0f]];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor blackColor];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe.titleLabel setTextColor:[UIColor whiteColor]];
    [whiteView addSubview:self.buttonSubscribe];
    [self updateToSubscribed:self.participant.subscribed.boolValue];
    
    [self.view addSubview:whiteView];
}

- (void)subscribe
{
    [[ObjectManager sharedManager] subscribeFor:self.participant
                                        success:^
                                        {
                                            [self updateToSubscribed:YES];
                                            [NotificationManager showSuccessMessage:@"Вы подписались на участника!"];
                                        }
                                        failure:nil
     ];
}

- (void)unsubscribe
{
    [[ObjectManager sharedManager] unsubscribeFrom:self.participant
                                           success:^
                                           {
                                               [self updateToSubscribed:NO];
                                               [NotificationManager showSuccessMessage:@"Вы отписались от участника!"];
                                           }
                                           failure:nil];
}

- (void)updateToSubscribed:(BOOL)subscribed
{
    SEL subscribeMethod = subscribed ? @selector(unsubscribe) : @selector(subscribe);
    SEL previuosMethod = subscribed ? @selector(subscribe) : @selector(unsubscribe);
    NSString *subscribeTitle = subscribed ? @"Отписаться" : @"Подписаться";
    NSString *subscribeImage = subscribed ? @"ButtonRed" : @"ButtonBar";
    CGFloat subscribeImageInset = subscribed ? 5.0f : 7.0f;
    
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:subscribeImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, subscribeImageInset, 0.0f, subscribeImageInset)] forState:UIControlStateNormal];
    [self.buttonSubscribe setTitle:subscribeTitle forState:UIControlStateNormal];
    [self.buttonSubscribe removeTarget:self action:previuosMethod forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSubscribe addTarget:self action:subscribeMethod forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
}

@end
