//
//  ParticipantViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 7/26/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ParticipantViewController.h"
#import "ParticipantModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIViewController+Puntr.h"

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
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, 305, 76)];
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
    
    self.buttonSubscribe = [[UIButton alloc] initWithFrame:CGRectMake(204, 28, 95, 40)];
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.buttonSubscribe setTitle:@"Подписаться" forState:UIControlStateNormal];
    [self.buttonSubscribe.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12.0f]];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor blackColor];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe.titleLabel setTextColor:[UIColor whiteColor]];
    [whiteView addSubview:self.buttonSubscribe];
    
    [self.view addSubview:whiteView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
}

@end
