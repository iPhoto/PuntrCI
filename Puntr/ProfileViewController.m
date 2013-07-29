//
//  ProfileViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import "ObjectManager.h"
#import "UserModel.h"
#import "NotificationManager.h"
#import "UIViewController+Puntr.h"

@interface ProfileViewController ()

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
@property (nonatomic, strong) NSArray *stars;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Профиль";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    [self addBalanceButton];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, 305, 128)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    UIView *greyView = [[UIView alloc]initWithFrame:CGRectMake(0, 78, 305, 58)];
    [greyView setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1]];
    [whiteView addSubview:greyView];
    whiteView.layer.cornerRadius = 3.75;
    whiteView.layer.masksToBounds = YES;
    
    self.stars = [[NSArray alloc] initWithObjects:[UIImageView new], [UIImageView new], [UIImageView new], [UIImageView new], [UIImageView new], nil];
    for(int i = 0; i<5; i++)
    {
        [[self.stars objectAtIndex:i] setFrame:CGRectMake(80 + 15*i, 55, 14, 13)];
        [whiteView addSubview:[self.stars objectAtIndex:i]];
    }
    self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(78, 10, 225, 15)];
    [self.labelName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    [whiteView addSubview:self.labelName];
    
    self.labelRating = [[UILabel alloc]initWithFrame:CGRectMake(78, 35, 55, 15)];
    [self.labelRating setFont:[UIFont fontWithName:@"ArialMT" size:13.0f]];
    [whiteView addSubview:self.labelRating];
    [self.labelRating setText:@"Рейтинг:"];
    
    self.labelRatingNumber = [[UILabel alloc]initWithFrame:CGRectMake(133, 35, 175, 15)];
    [self.labelRatingNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
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
    
    self.labelFollower = [[UILabel alloc]initWithFrame:CGRectMake(77, 105, 75, 15)];
    [self.labelFollower setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelFollower.shadowColor = [UIColor whiteColor];
    self.labelFollower.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelFollower setBackgroundColor:[UIColor clearColor]];
    [self.labelFollower setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelFollower];
    [self.labelFollower setText:@"Подписчиков"];
    
    self.labelAward = [[UILabel alloc]initWithFrame:CGRectMake(152, 105, 75, 15)];
    [self.labelAward setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelAward.shadowColor = [UIColor whiteColor];
    self.labelAward.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelAward setBackgroundColor:[UIColor clearColor]];
    [self.labelAward setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelAward];
    [self.labelAward setText:@"Наград"];
    
    self.labelRating = [[UILabel alloc]initWithFrame:CGRectMake(227, 105, 75, 15)];
    [self.labelRating setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    self.labelRating.shadowColor = [UIColor whiteColor];
    self.labelRating.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelRating setBackgroundColor:[UIColor clearColor]];
    [self.labelRating setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelRating];
    [self.labelRating setText:@"Побед/Пораж"];
    
    self.labelFollowNumber = [[UILabel alloc]initWithFrame:CGRectMake(2, 88, 75, 15)];
    [self.labelFollowNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    self.labelFollowNumber.shadowColor = [UIColor whiteColor];
    self.labelFollowNumber.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelFollowNumber setBackgroundColor:[UIColor clearColor]];
    [self.labelFollowNumber setTextAlignment:NSTextAlignmentCenter];
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
    [whiteView addSubview:self.labelAwardNumber];
    
    self.labelRatingNumber = [[UILabel alloc]initWithFrame:CGRectMake(227, 88, 75, 15)];
    [self.labelRatingNumber setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    self.labelRatingNumber.shadowColor = [UIColor whiteColor];
    self.labelRatingNumber.shadowOffset = CGSizeMake(0.0f, 1.5f);
    [self.labelRatingNumber setBackgroundColor:[UIColor clearColor]];
    [self.labelRatingNumber setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:self.labelRatingNumber];
    
    self.imageViewAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    [whiteView addSubview:self.imageViewAvatar];
    
    [self.view addSubview:whiteView];
    
    self.labelActivity = [[UILabel alloc]initWithFrame:CGRectMake(18, 150, 90, 15)];
    [self.labelActivity setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    [self.labelActivity setBackgroundColor:[UIColor clearColor]];
    [self.labelActivity setTextColor:[UIColor whiteColor]];
    [self.labelActivity setText:@"Активность"];
    [self.view addSubview:self.labelActivity];    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadProfile];
    [self updateBalance];
}

- (void)loadProfile {
    [[ObjectManager sharedManager] profileWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        UserModel *profile = (UserModel *)mappingResult.firstObject;
        NSLog(@"ProfileName: %@", profile.firstName);
        [self.imageViewAvatar setImageWithURL:profile.avatar];
        [self showStars:profile.rating.intValue];
        [self.labelName setText:profile.firstName];
        [self.labelRatingNumber setText:profile.topPosition.stringValue];
        [self.labelFollowNumber setText:profile.subscriptionsCount.stringValue];
        [self.labelFollowerNumber setText:profile.subscribersCount.stringValue];
        [self.labelAwardNumber setText:profile.badgesCount.stringValue];
        [self.labelRatingNumber setText:[NSString stringWithFormat:@"%@/%@",profile.winCount.stringValue,profile.lossCount.stringValue]];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [NotificationManager showError:error];
    }];
}

-(void)showStars:(int)count
{
    if(count<0 || count>5)
    {
        return;
    }
    int i = 0;
    for(; i< count; i++)
    {
        [[self.stars objectAtIndex:i] setImage:[UIImage imageNamed:@"StarSelected.png"]];
    }
    for(; i<5; i++)
    {
        [[self.stars objectAtIndex:i] setImage:[UIImage imageNamed:@"StarUnselected.png"]];
    }
}

@end
