//
//  EventViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 10.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CommentViewController.h"
#import "CollectionManager.h"
#import "EventModel.h"
#import "EventViewController.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "ParticipantViewController.h"
#import "StakeViewController.h"
#import "UIViewController+Puntr.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat TNItemSpacing = 12.0f;

@interface EventViewController ()

@property (nonatomic, strong, readonly) EventModel *event;

@property (nonatomic, strong) CollectionManager *collectionManager;

@property (nonatomic, strong) UIImageView *imageViewDelimiter;

@property (nonatomic, strong) UILabel *labelParticipantFirst;
@property (nonatomic, strong) UILabel *labelParticipantSecond;
@property (nonatomic, strong) UILabel *labelStatus;

@property (nonatomic, strong) UIButton *buttonParticipantFirst;
@property (nonatomic, strong) UIButton *buttonParticipantSecond;
@property (nonatomic, strong) UIButton *buttonSubscribe;
@property (nonatomic, strong) UIButton *buttonStake;

@end

@implementation EventViewController

- (id)initWithEvent:(EventModel *)event
{
    self = [super init];
    if (self)
    {
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Событие";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    UIBarButtonItem *buttonComment = [[UIBarButtonItem alloc] initWithTitle:@"Коммент." style:UIBarButtonItemStyleBordered target:self action:@selector(rightNavButtonTouched)];
    self.navigationItem.rightBarButtonItem = buttonComment;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
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
    
    self.buttonParticipantFirst = [[UIButton alloc] initWithFrame:CGRectMake(2 * coverMargin, coverMargin + 13, 128, 44)];
    [self.buttonParticipantFirst setBackgroundImage:[[UIImage imageNamed:@"ButtonGray"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)] forState:UIControlStateNormal];
    self.buttonParticipantFirst.titleLabel.font = fontParticipants;
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
    
    self.buttonParticipantSecond = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - (2 * coverMargin + 128), coverMargin + 13, 128, 44)];
    [self.buttonParticipantSecond setBackgroundImage:[[UIImage imageNamed:@"ButtonGray"]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)]
                                            forState:UIControlStateNormal];
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
    self.buttonSubscribe.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                    forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSubscribe];
    [self updateToSubscribed:self.event.subscribed.boolValue];
    
    self.buttonStake = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonStake.frame = CGRectMake(coverMargin * 3.0f + (screenWidth - coverMargin * 5.0f) / 2.0f, coverMargin + participantSize.height + 15.0f, (screenWidth - coverMargin * 5.0f) / 2.0f, 40.0f);
    [self.buttonStake setTitle:@"Ставить" forState:UIControlStateNormal];
    self.buttonStake.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonStake.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreen"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                forState:UIControlStateNormal];
    if (self.event.endTime)
    {
        self.buttonStake.enabled = NO;
        
    }
    [self.buttonStake addTarget:self action:@selector(stakeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonStake];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeEventComments modifierObjects:@[self.event]];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = CGRectMake(
                                      0.0f,
                                      CGRectGetMaxY(backgroundCover.frame) + TNItemSpacing,
                                      CGRectGetWidth(viewControllerFrame),
                                      CGRectGetHeight(viewControllerFrame) - (CGRectGetMaxY(backgroundCover.frame) + TNItemSpacing)
                                      );
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionManager reloadData];
}

- (void)rightNavButtonTouched
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[CommentViewController commentWithEvent:self.event]] animated:YES completion:nil
    ];
}

- (void)stakeButtonTouched
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[StakeViewController alloc] initWithEvent:self.event]] animated:YES completion:^{
    }];
}

- (void)showParticipant:(id)sender
{
    int i;
    if ((UIButton *)sender == self.buttonParticipantFirst)
    {
        i = 0;
    }
    else
    {
        i = 1;
    }
    [self.navigationController pushViewController:[ParticipantViewController controllerWithParticipant:self.event.participants[i]] animated:YES];
}

#pragma mark - Subscription

- (void)subscribe
{
    [[ObjectManager sharedManager] subscribeFor:self.event
                                        success:^
     {
         [self updateToSubscribed:YES];
         [NotificationManager showSuccessMessage:@"Вы подписались на событие!"];
     }
                                        failure:nil
     ];
}

- (void)unsubscribe
{
    [[ObjectManager sharedManager] unsubscribeFrom:self.event
                                           success:^
     {
         [self updateToSubscribed:NO];
         [NotificationManager showSuccessMessage:@"Вы отписались от события!"];
     }
                                           failure:nil];
}

- (void)updateToSubscribed:(BOOL)subscribed
{
    SEL subscribeMethod = subscribed ? @selector(unsubscribe) : @selector(subscribe);
    SEL previuosMethod = subscribed ? @selector(subscribe) : @selector(unsubscribe);
    NSString *subscribeTitle = subscribed ? @"Отписаться" : @"Подписаться";
    
    NSString *subscribeImage = subscribed ? @"unsubscribe" : @"ButtonDark";
    CGFloat subscribeImageInset = subscribed ? 7.0f : 8.0f;
    
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:subscribeImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, subscribeImageInset, 0.0f, subscribeImageInset)] forState:UIControlStateNormal];
    
    [self.buttonSubscribe setTitle:subscribeTitle forState:UIControlStateNormal];
    [self.buttonSubscribe removeTarget:self action:previuosMethod forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSubscribe addTarget:self action:subscribeMethod forControlEvents:UIControlEventTouchUpInside];
}

@end
