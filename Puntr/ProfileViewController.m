//
//  ProfileViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "SubscriptionsViewController.h"
#import "UIViewController+Puntr.h"
#import "UserModel.h"
#import "AwardsCollectionViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

static const CGFloat TNItemSpacing = 12.0f;

@interface ProfileViewController ()

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelRating;
@property (nonatomic, strong) UILabel *labelRatingNumber;
@property (nonatomic, strong) UILabel *labelFollow;
@property (nonatomic, strong) UILabel *labelFollowNumber;
@property (nonatomic, strong) UILabel *labelFollower;
@property (nonatomic, strong) UILabel *labelFollowerNumber;
@property (nonatomic, strong) UILabel *labelAward;
@property (nonatomic, strong) UILabel *labelAwardNumber;
@property (nonatomic, strong) UILabel *labelStats;
@property (nonatomic, strong) UILabel *labelStatsNumber;
@property (nonatomic, strong) UILabel *labelActivity;
@property (nonatomic, strong) UIImageView *imageViewAvatar;

@property (nonatomic, strong) UIButton *buttonSubscriptions;
@property (nonatomic, strong) UIButton *buttonFollower;
@property (nonatomic, strong) UIButton *buttonAwards;
@property (nonatomic, strong) UIButton *buttonStats;
@property (nonatomic, strong) UIButton *buttonSubscribe;

@property (nonatomic, strong) NSArray *stars;
@property (nonatomic, strong) NSNumber *userTag;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation ProfileViewController

- (id)initWithUser:(UserModel *)user
{
    self = [super init];
    if (self)
    {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.user)
    {
        self.user = [[ObjectManager sharedManager] loginedUser];
    }
    self.title = @"Профиль";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
    UIButton *buttonSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonSettings setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonSettings setImage:[UIImage imageNamed:@"IconSettings"] forState:UIControlStateNormal];
    [buttonSettings setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    [buttonSettings addTarget:self action:@selector(settingsButtonTouched) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:buttonSettings];
    
    self.navigationItem.leftBarButtonItem = settingsItem;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 305, 128)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    UIView *greyView = [[UIView alloc] initWithFrame:CGRectMake(0, 78, 305, 58)];
    [greyView setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1]];
    [whiteView addSubview:greyView];
    whiteView.layer.cornerRadius = 3.75;
    whiteView.layer.masksToBounds = YES;
    
    self.stars = [[NSArray alloc] initWithObjects:[UIImageView new], [UIImageView new], [UIImageView new], [UIImageView new], [UIImageView new], nil];
    for (int i = 0; i < 5; i++)
    {
        [[self.stars objectAtIndex:i] setFrame:CGRectMake(80 + 15 * i, 55, 14, 13)];
        [whiteView addSubview:[self.stars objectAtIndex:i]];
    }
    [self showStars:self.user.rating.intValue];
    
    self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(78, 10, 225, 15)];
    [self.labelName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    [self.labelName setText:self.user.firstName];
    [whiteView addSubview:self.labelName];
    
    self.labelRating = [[UILabel alloc]initWithFrame:CGRectMake(78, 35, 55, 15)];
    [self.labelRating setFont:[UIFont fontWithName:@"ArialMT" size:13.0f]];
    [whiteView addSubview:self.labelRating];
    [self.labelRating setText:@"Рейтинг:"];
    
    self.labelRatingNumber = [[UILabel alloc]initWithFrame:CGRectMake(133, 35, 175, 15)];
    [self.labelRatingNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    [self.labelRatingNumber setText:self.user.topPosition.stringValue];
    [whiteView addSubview:self.labelRatingNumber];
    [self.view addSubview:whiteView];
    
    self.labelFollow = [[UILabel alloc]initWithFrame:CGRectMake(2, 105, 75, 15)];
    [self.labelFollow setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelFollow.shadowColor = [UIColor whiteColor];
    self.labelFollow.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelFollow setBackgroundColor:[UIColor clearColor]];
    [self.labelFollow setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelFollow];
    [self.labelFollow setText:@"Подписок"];
    
    self.buttonSubscriptions = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonSubscriptions.frame = CGRectMake(
                                                   0.0f,
                                                   CGRectGetMinY(greyView.frame),
                                                   CGRectGetWidth(greyView.frame) / 4.0f,
                                                   CGRectGetHeight(whiteView.frame) - CGRectGetMinX(greyView.frame)
                                               );
    [self.buttonSubscriptions addTarget:self action:@selector(subscriptions) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.buttonSubscriptions];
    
    self.labelFollower = [[UILabel alloc]initWithFrame:CGRectMake(77, 105, 75, 15)];
    [self.labelFollower setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelFollower.shadowColor = [UIColor whiteColor];
    self.labelFollower.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelFollower setBackgroundColor:[UIColor clearColor]];
    [self.labelFollower setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelFollower];
    [self.labelFollower setText:@"Подписчиков"];
    
    self.buttonFollower = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonFollower.frame = CGRectMake(
                                            CGRectGetMaxX(self.buttonSubscriptions.frame),
                                            CGRectGetMinY(greyView.frame),
                                            CGRectGetWidth(greyView.frame) / 4.0f,
                                            CGRectGetHeight(whiteView.frame) - CGRectGetMinX(greyView.frame)
                                           );
    [self.buttonFollower addTarget:self action:@selector(followers) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.buttonFollower];
    
    
    self.labelAward = [[UILabel alloc]initWithFrame:CGRectMake(152, 105, 75, 15)];
    [self.labelAward setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelAward.shadowColor = [UIColor whiteColor];
    self.labelAward.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelAward setBackgroundColor:[UIColor clearColor]];
    [self.labelAward setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelAward];
    [self.labelAward setText:@"Наград"];
    
    self.buttonAwards = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonAwards.frame = CGRectMake(
                                           CGRectGetMaxX(self.buttonFollower.frame),
                                           CGRectGetMinY(greyView.frame),
                                           CGRectGetWidth(greyView.frame) / 4.0f,
                                           CGRectGetHeight(whiteView.frame) - CGRectGetMinX(greyView.frame)
                                           );
    [self.buttonAwards addTarget:self action:@selector(awardButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.buttonAwards];
    
    self.labelRating = [[UILabel alloc]initWithFrame:CGRectMake(227, 105, 75, 15)];
    [self.labelRating setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelRating.shadowColor = [UIColor whiteColor];
    self.labelRating.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelRating setBackgroundColor:[UIColor clearColor]];
    [self.labelRating setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelRating];
    [self.labelRating setText:@"Побед/Пораж"];
    
    self.buttonStats = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonStats.frame = CGRectMake(
                                         CGRectGetMaxX(self.buttonAwards.frame),
                                         CGRectGetMinY(greyView.frame),
                                         CGRectGetWidth(greyView.frame) / 4.0f,
                                         CGRectGetHeight(whiteView.frame) - CGRectGetMinX(greyView.frame)
                                         );
    [self.buttonStats addTarget:self action:@selector(awardButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.buttonStats];

    self.labelFollowNumber = [[UILabel alloc]initWithFrame:CGRectMake(2, 88, 75, 15)];
    [self.labelFollowNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    self.labelFollowNumber.shadowColor = [UIColor whiteColor];
    self.labelFollowNumber.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelFollowNumber setBackgroundColor:[UIColor clearColor]];
    [self.labelFollowNumber setTextAlignment:NSTextAlignmentCenter];
    [self.labelFollowNumber setText:self.user.subscriptionsCount.stringValue];
    [whiteView addSubview:self.labelFollowNumber];
    
    self.labelFollowerNumber = [[UILabel alloc]initWithFrame:CGRectMake(77, 88, 75, 15)];
    [self.labelFollowerNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    self.labelFollowerNumber.shadowColor = [UIColor whiteColor];
    self.labelFollowerNumber.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelFollowerNumber setBackgroundColor:[UIColor clearColor]];
    [self.labelFollowerNumber setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelFollowerNumber];
    
    self.labelAwardNumber = [[UILabel alloc]initWithFrame:CGRectMake(152, 88, 75, 15)];
    [self.labelAwardNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    self.labelAwardNumber.shadowColor = [UIColor whiteColor];
    self.labelAwardNumber.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelAwardNumber setBackgroundColor:[UIColor clearColor]];
    [self.labelAwardNumber setTextAlignment:NSTextAlignmentCenter];
    [self.labelAwardNumber setText:self.user.badgesCount.stringValue];
    [whiteView addSubview:self.labelAwardNumber];
    
    self.labelRatingNumber = [[UILabel alloc]initWithFrame:CGRectMake(227, 88, 75, 15)];
    [self.labelRatingNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    self.labelRatingNumber.shadowColor = [UIColor whiteColor];
    self.labelRatingNumber.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelRatingNumber setBackgroundColor:[UIColor clearColor]];
    [self.labelRatingNumber setTextAlignment:NSTextAlignmentCenter];
    [self.labelRatingNumber setText:[NSString stringWithFormat:@"%@/%@", self.user.winCount.stringValue, self.user.lossCount.stringValue]];
    [whiteView addSubview:self.labelRatingNumber];
    
    self.imageViewAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    [self.imageViewAvatar setImageWithURL:self.user.avatar];
    [whiteView addSubview:self.imageViewAvatar];
    
    if (![self.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]])
    {
        self.buttonSubscribe = [[UIButton alloc] initWithFrame:CGRectMake(204, 28, 95, 40)];
        [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                        forState:UIControlStateNormal];
        [self.buttonSubscribe setTitle:@"Подписаться" forState:UIControlStateNormal];
        [self.buttonSubscribe.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12.0f]];
        self.buttonSubscribe.titleLabel.shadowColor = [UIColor blackColor];
        self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
        [self.buttonSubscribe.titleLabel setTextColor:[UIColor whiteColor]];
        [whiteView addSubview:self.buttonSubscribe];
    }
    
    [self.view addSubview:whiteView];
    
    self.labelActivity = [[UILabel alloc]initWithFrame:CGRectMake(18, 150, 90, 15)];
    [self.labelActivity setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    [self.labelActivity setBackgroundColor:[UIColor clearColor]];
    [self.labelActivity setTextColor:[UIColor whiteColor]];
    [self.labelActivity setText:@"Активность"];
    [self.view addSubview:self.labelActivity];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeActivities modifierObject:self.user];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = CGRectMake(
                                      0.0f,
                                      CGRectGetMaxY(self.labelActivity.frame) + TNItemSpacing,
                                      CGRectGetWidth(viewControllerFrame),
                                      CGRectGetHeight(viewControllerFrame) - (CGRectGetMaxY(self.labelActivity.frame) + TNItemSpacing)
                                      );
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadProfile];
    [self updateBalance];
    [self.collectionManager reloadData];
}

- (void)settingsButtonTouched
{
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)awardButtonTouched
{
    [self.navigationController pushViewController:[[AwardsCollectionViewController alloc] init] animated:YES];
}

- (void)loadProfile
{
    [[ObjectManager sharedManager] userWithTag:self.user.tag success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
        {
            UserModel *profile = (UserModel *)mappingResult.firstObject;
            NSLog(@"ProfileName: %@", profile.firstName);
            [self.imageViewAvatar setImageWithURL:profile.avatar];
            [self showStars:profile.rating.intValue];
            [self.labelName setText:profile.firstName];
            [self.labelRatingNumber setText:profile.topPosition.stringValue];
            [self.labelFollowNumber setText:profile.subscriptionsCount.stringValue];
            [self.labelFollowerNumber setText:profile.subscribersCount.stringValue];
            [self.labelAwardNumber setText:profile.badgesCount.stringValue];
            [self.labelRatingNumber setText:[NSString stringWithFormat:@"%@/%@", profile.winCount.stringValue, profile.lossCount.stringValue]];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error)
        {
            [NotificationManager showError:error];
        }
    ];
}

- (void)showStars:(int)count
{
    if (count < 0 || count > 5)
    {
        return;
    }
    int i = 0;
    for (; i < count; i++)
    {
        [[self.stars objectAtIndex:i] setImage:[UIImage imageNamed:@"StarSelected.png"]];
    }
    for (; i < 5; i++)
    {
        [[self.stars objectAtIndex:i] setImage:[UIImage imageNamed:@"StarUnselected.png"]];
    }
}

- (void)subscriptions
{
    [self.navigationController pushViewController:[[SubscriptionsViewController alloc] initWithUser:self.user] animated:YES];
}

- (void)followers
{
    [self.navigationController pushViewController:[[SubscriptionsViewController alloc] initWithUser:self.user] animated:YES];
}


@end
