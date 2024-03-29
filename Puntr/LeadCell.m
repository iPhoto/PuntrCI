//
//  LeadCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LeadButton.h"
#import "LeadCell.h"
#import "LeadManager.h"
#import "Models.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "SocialManager.h"
#import "SetViewController.h"
#import "UILabel+Puntr.h"
#import <QuartzCore/QuartzCore.h>
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

#import "GPUImage.h"

static const CGFloat TNCornerRadius = 3.75f;
static const CGFloat TNHeightButton = 31.0f;
static const CGFloat TNHeightSwitch = 27.0f;
static const CGFloat TNHeightText = 12.0f;
static const CGFloat TNMarginGeneral = 8.0f;
static const CGFloat TNPuntrBetCoefficient = 1.9f;
static const CGFloat TNSideBadge = 136.0f;
static const CGFloat TNSideImage = 28.0f;
static const CGFloat TNSideImageLarge = 60.0f;
static const CGFloat TNSideImageMedium = 22.0f;
static const CGFloat TNSideImageSmall = 12.0f;
static const CGFloat TNWidthButtonLarge = 94.0f;
static const CGFloat TNWidthButtonSmall = 62.0f;
static const CGFloat TNWidthCell = 306.0f;
static const CGFloat TNWidthSwitch = 78.0f;

#define TNFontSmall [UIFont fontWithName:@"ArialMT" size:10.4f]
#define TNFontSmallBold [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]
#define TNColorOrange [UIColor colorWithRed:0.80f green:0.60f blue:0.20f alpha:1.00f]
#define TNRemove(property) [property removeFromSuperview]; property = nil;

@interface LeadCell ()

@property (nonatomic) CGFloat usedHeight;
@property (nonatomic) CGFloat usedWidth;
@property (nonatomic) BOOL blackBackground;
@property (nonatomic, strong) id model;
@property (nonatomic, strong) id submodel;

// Activity
@property (nonatomic, strong) UILabel *labelActivityCreatedAt;

// Award
@property (nonatomic, retain) UIImageView *imageViewAward;
@property (nonatomic, retain) UILabel *labelAwardPointsCount;
@property (nonatomic, retain) UILabel *labelAwardTitle;
//@property (nonatomic, retain) UILabel *labelAwardDescription;
//@property (nonatomic, retain) UIButton *buttonAwardShare;

// Bet
@property (nonatomic, strong) BetModel *bet;
@property (nonatomic, strong) UIImageView *imageViewBetAvatarCreator;
@property (nonatomic, strong) UIImageView *imageViewBetAvatarOpponent;
@property (nonatomic, strong) UILabel *labelBetNameCreator;
@property (nonatomic, strong) UILabel *labelBetNameOpponent;
@property (nonatomic, strong) UIImageView *imageViewBetSwords;
@property (nonatomic, strong) UIButton *buttonBet;

// Category
@property (nonatomic, strong) UILabel *labelCategoryTitle;
@property (nonatomic, strong) UIImageView *imageViewCategoryImage;

// Coefficient
@property (nonatomic, strong) UILabel *labelCoefficientValue;

// Comment
@property (nonatomic, strong) UILabel *labelCommentMessage;

// Component
@property (nonatomic, strong) UILabel *labelComponentCombined;

// Event
@property (nonatomic, strong) EventModel *event;
@property (nonatomic, strong) UILabel *labelEventStartEndTime;
@property (nonatomic, strong) UIImageView *imageViewEventLive;
@property (nonatomic, strong) UIImageView *imageViewEventStakesCount;
@property (nonatomic, strong) UILabel *labelEventStakesCount;
@property (nonatomic, strong) UILabel *labelEventStatus;
@property (nonatomic, strong) LeadButton *buttonEventBet;
@property (nonatomic, strong) LeadButton *buttonEventStake;

// Group
@property (nonatomic, strong) GroupModel *group;
@property (nonatomic, strong) UILabel *labelGroupTitle;
@property (nonatomic, strong) UIImageView *imageViewGroupImage;

// Lead Buttons
@property (nonatomic, strong) NSMutableArray *leadButtons;

// Line
@property (nonatomic, strong) UILabel *labelLineTitle;

// Loading
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

// Money
@property (nonatomic, strong) UILabel *labelMoneyAmount;
@property (nonatomic, strong) UIImageView *imageViewMoney;

// Participant
@property (nonatomic, strong) ParticipantModel *participant;
@property (nonatomic, strong) NSMutableArray *participantLogos;
@property (nonatomic, strong) NSMutableArray *participantTitles;
@property (nonatomic, strong) UILabel *labelParticipantSubscribersCount;
@property (nonatomic, strong) UIImageView *imageViewParticipantSubscribersCount;

// Privacy and Push
@property (nonatomic, strong) UILabel *labelDynamicSelectionTitle;
@property (nonatomic, strong) UILabel *labelDynamicSelectionDescription;
@property (nonatomic, strong) UISwitch *switchDynamicSelection;

// Score
@property (nonatomic, strong) NSMutableArray *scoreTimes;
@property (nonatomic, strong) NSMutableArray *scoreNames;
@property (nonatomic, strong) NSMutableArray *scoreCategories;
@property (nonatomic, strong) NSMutableArray *scoreStatuses;

// Search
@property (nonatomic, strong) UISearchBar *searchBar;

// Stake
@property (nonatomic, strong) UIView *viewStakeStatusBackground;
@property (nonatomic, strong) UILabel *labelStakeStatus;

// Subscription
@property (nonatomic, strong) UIButton *buttonSubscribe;

// Switch
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

// Tournament
@property (nonatomic, strong) TournamentModel *tournament;
@property (nonatomic, strong) UILabel *labelTournamentTitle;
@property (nonatomic, strong) UIImageView *imageViewTournamentArrow;
@property (nonatomic, strong) UIButton *buttonTournament;

// User
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) UILabel *labelUserName;
@property (nonatomic, strong) UILabel *labelUserTopPosition;
@property (nonatomic, strong) UIImageView *imageViewUserAvatar;
@property (nonatomic, strong) NSMutableArray *userStars;
@property (nonatomic, strong) UILabel *labelUserAwardsCount;
@property (nonatomic, strong) UILabel *labelUserAwardsTitle;
@property (nonatomic, strong) UILabel *labelUserSubscribersCount;
@property (nonatomic, strong) UILabel *labelUserSubscribersTitle;
@property (nonatomic, strong) UILabel *labelUserSubscriptionsCount;
@property (nonatomic, strong) UILabel *labelUserSubscriptionsTitle;
@property (nonatomic, strong) UILabel *labelUserActivity;
@property (nonatomic, strong) UIView *userBackgroundProfile;
@property (nonatomic, strong) UIView *userBackgroundButtons;

@property (nonatomic, strong) UIImageView *imageViewBanner;
@property (nonatomic, strong) NSMutableArray *delimiters;

@end

@implementation LeadCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _delimiters = [NSMutableArray array];
        _leadButtons = [NSMutableArray array];
        _participantLogos = [NSMutableArray array];
        _participantTitles = [NSMutableArray array];
        _userStars = [NSMutableArray array];
        _scoreTimes = [NSMutableArray array];
        _scoreNames = [NSMutableArray array];
        _scoreCategories = [NSMutableArray array];
        _scoreStatuses = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Reloading

- (void)prepareForReuse
{
    self.usedHeight = 0.0f;
    self.usedWidth = 0.0f;
    self.blackBackground = NO;
    self.model = nil;
    self.submodel = nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0.0;
    self.layer.masksToBounds = NO;
    
    // Activity
    TNRemove(self.labelActivityCreatedAt)
    
    // Award
    TNRemove(self.imageViewAward)
    TNRemove(self.labelAwardPointsCount)
    TNRemove(self.labelAwardTitle)
    
    // Bet
    self.bet = nil;
    TNRemove(self.imageViewBetAvatarCreator)
    TNRemove(self.imageViewBetAvatarOpponent)
    TNRemove(self.labelBetNameCreator)
    TNRemove(self.labelBetNameOpponent)
    TNRemove(self.imageViewBetSwords)
    TNRemove(self.buttonBet)
    
    // Category
    TNRemove(self.labelCategoryTitle)
    TNRemove(self.imageViewCategoryImage)
    
    // Coefficient
    TNRemove(self.labelCoefficientValue)
    
    // Comment
    TNRemove(self.labelCommentMessage)
    
    // Component
    TNRemove(self.labelComponentCombined)
    
    // Event
    self.event = nil;
    TNRemove(self.labelEventStartEndTime)
    TNRemove(self.imageViewEventLive)
    TNRemove(self.imageViewEventStakesCount)
    TNRemove(self.labelEventStakesCount)
    TNRemove(self.labelEventStatus)
    TNRemove(self.buttonEventBet)
    TNRemove(self.buttonEventStake)
    
    // Group
    self.group = nil;
    TNRemove(self.labelGroupTitle)
    TNRemove(self.imageViewGroupImage)
    
    // Lead Buttons
    [self cleanArray:self.leadButtons];
    
    // Line
    TNRemove(self.labelLineTitle)
    
    // Loading
    TNRemove(self.activityIndicator)
    
    // Money
    TNRemove(self.labelMoneyAmount)
    TNRemove(self.imageViewMoney)
    
    // Participant
    self.participant = nil;
    [self cleanArray:self.participantLogos];
    [self cleanArray:self.participantTitles];
    TNRemove(self.labelParticipantSubscribersCount)
    TNRemove(self.imageViewParticipantSubscribersCount)
    
    // Privacy and Push
    TNRemove(self.labelDynamicSelectionTitle)
    TNRemove(self.labelDynamicSelectionDescription)
    TNRemove(self.switchDynamicSelection)
    
    // Score
    [self cleanArray:self.scoreTimes];
    [self cleanArray:self.scoreNames];
    [self cleanArray:self.scoreCategories];
    [self cleanArray:self.scoreStatuses];
    
    // Search
    TNRemove(self.searchBar)
    
    // Stake
    TNRemove(self.viewStakeStatusBackground)
    TNRemove(self.labelStakeStatus)
    
    // Subscription
    TNRemove(self.buttonSubscribe)
    
    // Switch
    TNRemove(self.segmentedControl)
    
    // Tournament
    self.tournament = nil;
    TNRemove(self.labelTournamentTitle)
    TNRemove(self.imageViewTournamentArrow)
    
    // User
    self.user = nil;
    TNRemove(self.labelUserName)
    TNRemove(self.labelUserTopPosition)
    TNRemove(self.imageViewUserAvatar)
    [self cleanArray:self.userStars];
    TNRemove(self.labelUserAwardsCount)
    TNRemove(self.labelUserAwardsTitle)
    TNRemove(self.labelUserSubscribersCount)
    TNRemove(self.labelUserSubscribersTitle)
    TNRemove(self.labelUserSubscriptionsCount)
    TNRemove(self.labelUserSubscriptionsTitle)
    TNRemove(self.labelUserActivity)
    TNRemove(self.userBackgroundButtons)
    TNRemove(self.userBackgroundProfile)
    
    // Miscelanouos
    TNRemove(self.imageViewBanner)
    [self cleanArray:self.delimiters];
 
    [self sendDelegateHideKeyboard];
}

#pragma mark - Size Calculation

+ (CGSize)sizeForModel:(id)model
{
    LeadCell *cell = [[self alloc] init];
    cell.usedWidth = TNWidthCell;
    [cell loadWithModel:model];
    return CGSizeMake(cell.usedWidth, cell.usedHeight + TNMarginGeneral);
}

#pragma mark - General Loading

- (void)loadWithModel:(id)model
{
    self.model = model;
    
    if ([model isMemberOfClass:[ActivityModel class]])
    {
        [self loadWithActivity:(ActivityModel *)model];
    }
    else if ([model isMemberOfClass:[AwardModel class]])
    {
        [self loadWithAward:(AwardModel *)model];
    }
    else if ([model isMemberOfClass:[BetModel class]])
    {
        [self loadWithBet:(BetModel *)model];
    }
    else if ([model isMemberOfClass:[CommentModel class]])
    {
        CommentModel *comment = (CommentModel *)model;
        [self blackCell];
        [self displayTopRightTime:comment.createdAt];
        [self loadWithComment:comment];
    }
    else if ([model isMemberOfClass:[DynamicSelectionModel class]])
    {
        [self loadWithDynamicSelection:(DynamicSelectionModel *)model];
    }
    else if ([model isMemberOfClass:[EventModel class]])
    {
        [self blackCell];
        EventModel *event = (EventModel *)model;
        if (event.scores)
        {
            [self loadwithEventMaster:event];
        }
        else
        {
            [self loadWithEvent:(EventModel *)model];
        }
    }
    else if ([model isMemberOfClass:[GroupModel class]])
    {
        self.group = (GroupModel *)model;
        [self blackCell];
        [self displayGroup:(GroupModel *)model final:YES];
    }
    else if ([model isMemberOfClass:[LoadModel class]])
    {
        [self displayLoading];
    }
    else if ([model isMemberOfClass:[NewsModel class]])
    {
        [self loadWithNews:(NewsModel *)model];
    }
    else if ([model isMemberOfClass:[ParticipantModel class]])
    {
        self.participant = (ParticipantModel *)model;
        [self loadWithParticipant:self.participant];
    }
    else if ([model isMemberOfClass:[PushSettingsModel class]] || [model isMemberOfClass:[PrivacySettingsModel class]])
    {
        [self loadWithDynamicSelection:(DynamicSelectionModel *)model];
    }
    else if ([model isMemberOfClass:[SearchModel class]])
    {
        [self displaySearch:(SearchModel *)model];
    }
    else if ([model isMemberOfClass:[StakeModel class]])
    {
        StakeModel *stake = (StakeModel *)model;
        [self displayBackgroundForStake:stake];
        if (stake.event.banner && ![PuntrUtilities isEventVisible])
        {
            [self displayBanner:stake.event.banner];
        }
        [self displayTopRightTime:stake.createdAt];
        [self loadWithStake:stake];
    }
    else if ([model isMemberOfClass:[SubscriberModel class]])
    {
        SubscriptionModel *subscription = [[SubscriptionModel alloc] init];
        subscription.user = [(SubscriberModel *)model user];
        [self loadWithSubscription:subscription];
    }
    else if ([model isMemberOfClass:[SubscriptionModel class]])
    {
        [self loadWithSubscription:(SubscriptionModel *)model];
    }
    else if ([model isMemberOfClass:[SwitchModel class]])
    {
        [self loadWithSwitch:(SwitchModel *)model];
    }
    else if ([model isMemberOfClass:[TournamentModel class]])
    {
        [self blackCell];
        [self loadWithTournament:(TournamentModel *)model];
    }
    else if ([model isMemberOfClass:[UserModel class]])
    {
        self.user = (UserModel *)model;
        if ([PuntrUtilities isProfileVisible])
        {
            [self loadWithProfile:self.user];
        }
        else
        {
            [self loadWithUser:self.user];
        }
    }
}

#pragma mark -

- (void)loadWithActivity:(ActivityModel *)activity
{
    [self blackCell];
    [self displayTopRightTime:activity.createdAt];
    if (activity.stake)
    {
        [self loadWithStake:activity.stake];
    }
    else if (activity.comment)
    {
        [self loadWithComment:activity.comment];
    }
    else if (activity.participant)
    {
        SubscriptionModel *subscription = [[SubscriptionModel alloc] init];
        subscription.participant = activity.participant;
        [self loadWithSubscription:subscription];
    }
    else if (activity.event)
    {
        SubscriptionModel *subscription = [[SubscriptionModel alloc] init];
        subscription.event = activity.event;
        [self loadWithSubscription:subscription];
    }
    else if (activity.tournament)
    {
        SubscriptionModel *subscription = [[SubscriptionModel alloc] init];
        subscription.tournament = activity.tournament;
        [self loadWithSubscription:subscription];
    }
    else if (activity.user)
    {
        SubscriptionModel *subscription = [[SubscriptionModel alloc] init];
        subscription.user = activity.user;
        [self loadWithSubscription:subscription];
    }
}

- (void)loadWithAward:(AwardModel *)award
{
    [self blackCell];
    self.usedHeight = TNSideBadge;
    self.usedWidth = TNSideBadge;
    [self displayAward:award];
}

- (void)loadWithBet:(BetModel *)bet
{
    [self blackCell];
    self.bet = bet;
    if (bet.event.banner)
    {
        [self displayBanner:bet.event.banner];
    }
    [self displayTopRightTime:bet.createdAt];
    [self displayTournament:bet.event.tournament arrow:YES final:NO];
    [self displayCategory:bet.event.tournament.category];
    [self displayParticipants:bet.event.participants final:NO];
    [self displayCreator:bet.creator opponent:bet.opponent final:NO];
    
    UserModel *loginedUser = [[ObjectManager sharedManager] loginedUser];
    BOOL isCreator = [bet.creator isEqualToUser:loginedUser];
    BOOL isOpponent = [bet.opponent isEqualToUser:loginedUser];
    BOOL isLoginedUser = isCreator || isOpponent;
    if (isLoginedUser)
    {
        NSString *status;
        if (bet.winnerTag)
        {
            if ([bet.winnerTag isEqualToNumber:loginedUser.tag])
            {
                status = @"won";
            }
            else
            {
                status = @"loss";
            }
            [self displayLine:bet.line components:bet.line.components coefficient:nil final:NO];
            [self displayStakeStatus:status
                               money:bet.money
                         coefficient:nil
                               final:YES];
        }
        else
        {
            [self displayLine:bet.line components:bet.line.components coefficient:nil final:YES];
        }
        
    }
    else
    {
        [self displayLine:bet.line components:bet.line.components coefficient:nil final:YES];
    }
}


- (void)loadWithComment:(CommentModel *)comment
{
    self.event = comment.event;
    self.tournament = comment.event.tournament;
    self.user = comment.user;
    if (![PuntrUtilities isEventVisible])
    {
        [self displayUser:comment.user message:comment.message final:NO];
        [self displayTournament:comment.event.tournament arrow:YES final:NO];
        [self displayCategory:comment.event.tournament.category];
        [self displayParticipants:comment.event.participants final:NO];
        [self displayStartTime:comment.event.startTime endTime:comment.event.endTime stakesCount:comment.event.stakesCount final:YES];
    }
    else
    {
        [self displayUser:comment.user message:comment.message final:YES];
    }
}

- (void)loadWithDynamicSelection:(DynamicSelectionModel *)dynamicSelection
{
    [self blackCell];
    if(dynamicSelection.slug)
    {
        [self displayDynamicSelection:dynamicSelection];
    }
}

- (void)loadWithEvent:(EventModel *)event
{
    self.event = event;
    self.submodel = event;
    self.tournament = event.tournament;
    if (event.banner)
    {
        [self displayBanner:event.banner];
    }
    if (![PuntrUtilities isTournamentVisible])
    {
        [self displayTournament:event.tournament arrow:YES final:NO];
    }
    if (![event.endTime isEqualToDate:[event.endTime earlierDate:[NSDate date]]])
    {
        [self displayButtonStake];
    }
    [self displayCategory:event.tournament.category];
    [self displayParticipants:event.participants final:NO];
    [self displayStartTime:event.startTime endTime:event.endTime stakesCount:event.stakesCount final:YES];
}

- (void)loadwithEventMaster:(EventModel *)event
{
    self.event = event;
    self.submodel = self.event;
    if (event.banner)
    {
        [self displayBanner:event.banner];
    }
    if (event.participants && event.participants.count > 0)
    {
        [self displayParticipantsMaster:event.participants final:NO];
    }
    if (event.scores.count > 0)
    {
        [self displayButtonsEventFinal:NO];
        for (ScoreModel *score in event.scores)
        {
            [self displayScore:score];
            if ([[(ScoreModel *)event.scores.lastObject time] isEqualToNumber:score.time])
            {
                [self makeFinal:YES];
            }
            else
            {
                [self makeFinal:NO];
            }
        }
    }
    else
    {
        [self displayButtonsEventFinal:YES];
    }
}

- (void)loadWithNews:(NewsModel *)news
{
    [self blackCell];
    if (news.stake)
    {
        [self displayTopRightTime:news.createdAt];
        [news.stake setType:news.type];
        [self loadWithStake:news.stake];
    }
    else if (news.comment)
    {
        [self displayTopRightTime:news.createdAt];
        [self loadWithComment:news.comment];
    }
    else if (news.event)
    {
        self.event = news.event;
        self.submodel = news.event;
        self.tournament = news.event.tournament;
        if (news.event.banner) {
            [self displayBanner:news.event.banner];
        }
        [self displayTopRightTime:news.createdAt];
        [self displayTournament:news.event.tournament arrow:YES final:NO];
        if (![news.event.endTime isEqualToDate:[news.event.endTime earlierDate:[NSDate date]]])
        {
            [self displayButtonStake];
        }
        [self displayCategory:news.event.tournament.category];
        [self displayParticipants:news.event.participants final:NO];
        [self displayStartTime:news.event.startTime endTime:news.event.endTime stakesCount:news.event.stakesCount final:YES];
    }
}

- (void)loadWithParticipant:(ParticipantModel *)participant
{
    self.submodel = participant;
    
    [self blackCell];
    [self displaySubscribedForObject:participant];
    
    // Logo
    CGFloat logoWidth = 0.0f;
    if (participant.logo)
    {
        UIImageView *imageViewParticipantLogo = [[UIImageView alloc] init];
        imageViewParticipantLogo.frame = CGRectMake(
                                                       TNMarginGeneral,
                                                       TNMarginGeneral,
                                                       TNSideImageLarge,
                                                       TNSideImageLarge
                                                   );
        [imageViewParticipantLogo imageWithUrl:[participant.logo URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
        [self roundCornersForView:imageViewParticipantLogo];
        [self.participantLogos addObject:imageViewParticipantLogo];
        [self addSubview:imageViewParticipantLogo];
        
        logoWidth = CGRectGetWidth(imageViewParticipantLogo.frame) + TNMarginGeneral;
    }
    
    CGFloat TNWidthLabel = TNWidthCell - TNMarginGeneral * 2.0f - logoWidth - TNWidthButtonLarge - TNMarginGeneral;
    
    // Name
    UILabel *labelParticipantTitle = [UILabel labelSmallBold:YES black:self.blackBackground];
    labelParticipantTitle.frame = CGRectMake(
                                                logoWidth + TNMarginGeneral,
                                                TNMarginGeneral,
                                                TNWidthLabel,
                                                TNHeightText
                                            );
    labelParticipantTitle.text = participant.title;
    [self.participantTitles addObject:labelParticipantTitle];
    [self addSubview:labelParticipantTitle];
    
    CGSize sizeParticipantLogo = CGSizeMake(10.0f, 9.0f);
    self.imageViewParticipantSubscribersCount = [[UIImageView alloc] init];
    self.imageViewParticipantSubscribersCount.frame = CGRectMake(
                                                                    logoWidth + TNMarginGeneral,
                                                                    CGRectGetMaxY(labelParticipantTitle.frame) + TNMarginGeneral,
                                                                    sizeParticipantLogo.width,
                                                                    sizeParticipantLogo.height
                                                                );
    self.imageViewParticipantSubscribersCount.image = [UIImage imageNamed:@"IconUser"];
    [self addSubview:self.imageViewParticipantSubscribersCount];
    
    self.labelParticipantSubscribersCount = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelParticipantSubscribersCount.frame = CGRectMake(
                                                                CGRectGetMaxX(self.imageViewParticipantSubscribersCount.frame) + TNMarginGeneral,
                                                                CGRectGetMaxY(labelParticipantTitle.frame) + TNMarginGeneral,
                                                                TNWidthLabel,
                                                                TNHeightText
                                                            );
    self.labelParticipantSubscribersCount.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Fans", nil), participant.subscribersCount.stringValue];
    [self addSubview:self.labelParticipantSubscribersCount];
    
    CGFloat maxY = participant.logo ? TNMarginGeneral + TNSideImageLarge : CGRectGetMaxY(self.labelParticipantSubscribersCount.frame);
    
    [self placeButtonForObject:participant maxY:maxY];
    
    self.usedHeight = maxY;
    
    [self makeFinal:YES];
}

- (void)loadWithProfile:(UserModel *)user
{
    CGFloat avatarWidth = 0.0f;
    
    CGFloat TNHeightBackgroundButtons = 50.0f;
    
    // Background User
    
    self.userBackgroundProfile = [[UIView alloc] init];
    self.userBackgroundProfile.frame = CGRectMake(
                                                     0.0f,
                                                     0.0f,
                                                     TNWidthCell,
                                                     TNSideImageLarge + TNMarginGeneral * 2.0f + TNHeightBackgroundButtons
                                                 );
    self.userBackgroundProfile.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [self addSubview:self.userBackgroundProfile];
    
    // Avatar
    if (user.avatar)
    {
        self.imageViewUserAvatar = [[UIImageView alloc] init];
        self.imageViewUserAvatar.frame = CGRectMake(
                                                       TNMarginGeneral,
                                                       TNMarginGeneral,
                                                       TNSideImageLarge,
                                                       TNSideImageLarge
                                                   );
        [self.imageViewUserAvatar imageWithUrl:[user.avatar URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
        [self roundCornersForView:self.imageViewUserAvatar];
        [self addSubview:self.imageViewUserAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewUserAvatar.frame) + TNMarginGeneral;
    }
    
    CGFloat TNWidthLabel = TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth;
    
    // Name
    self.labelUserName = [UILabel labelSmallBold:YES black:YES];
    self.labelUserName.frame = CGRectMake(
                                             avatarWidth + TNMarginGeneral,
                                             TNMarginGeneral,
                                             TNWidthLabel,
                                             TNHeightText
                                         );
    self.labelUserName.text = [self nameFromUser:user];
    [self addSubview:self.labelUserName];
    
    // Top Position
    self.labelUserTopPosition = [UILabel labelSmallBold:YES black:YES];
    self.labelUserTopPosition.frame = CGRectMake(
                                                    avatarWidth + TNMarginGeneral,
                                                    CGRectGetMaxY(self.labelUserName.frame) + TNHeightText,
                                                    TNWidthLabel,
                                                    TNHeightText
                                                );
    self.labelUserTopPosition.text = [NSString stringWithFormat:@"ROI: %@", user.rating.stringValue];
    [self addSubview:self.labelUserTopPosition];
    
    CGFloat TNHeightBackgroundUser = TNMarginGeneral + TNSideImageLarge + TNMarginGeneral;
    
    // Background Buttons
    
    self.userBackgroundButtons = [[UIView alloc] init];
    self.userBackgroundButtons.frame = CGRectMake(
                                                     0.0f,
                                                     TNHeightBackgroundUser,
                                                     TNWidthCell,
                                                     TNHeightBackgroundButtons
                                                 );
    self.userBackgroundButtons.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
    [self.userBackgroundProfile addSubview:self.userBackgroundButtons];
    
    [self roundCornersForView:self.userBackgroundProfile];
    
    CGFloat TNMarginBackgroundButtons = 1.0f;
    NSUInteger TNNumberBackgroundButtons = 3;
    
    // Subscriptions
    self.labelUserSubscriptionsCount = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelUserSubscriptionsCount.frame = CGRectMake(
                                                           0.0f,
                                                           TNHeightBackgroundUser + TNMarginBackgroundButtons + TNMarginGeneral,
                                                           TNWidthCell / TNNumberBackgroundButtons,
                                                           TNHeightText
                                                       );
    self.labelUserSubscriptionsCount.shadowColor = [UIColor whiteColor];
    self.labelUserSubscriptionsCount.shadowOffset = CGSizeMake(0.0f, 1.5f);
    self.labelUserSubscriptionsCount.text = user.subscriptionsCount.stringValue;
    self.labelUserSubscriptionsCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelUserSubscriptionsCount];
    
    
    self.labelUserSubscriptionsTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelUserSubscriptionsTitle.frame = CGRectMake(
                                                           0.0f,
                                                           CGRectGetMaxY(self.labelUserSubscriptionsCount.frame) + TNMarginGeneral,
                                                           TNWidthCell / TNNumberBackgroundButtons,
                                                           TNHeightText
                                                       );
    self.labelUserSubscriptionsTitle.shadowColor = [UIColor whiteColor];
    self.labelUserSubscriptionsTitle.shadowOffset = CGSizeMake(0.0f, 1.5f);
    self.labelUserSubscriptionsTitle.text = NSLocalizedString(@"Subscriptions", nil);
    self.labelUserSubscriptionsTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelUserSubscriptionsTitle];
    
    CGSize sizeDelimiter = CGSizeMake(2.0f, TNHeightBackgroundButtons - TNMarginBackgroundButtons * 2.0f - TNMarginGeneral * 2.0f);
    UIImage *imageDelimiter = [[UIImage imageNamed:@"DelimiterProfile"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    UIImageView *delimiterSubscriptions = [[UIImageView alloc] init];
    delimiterSubscriptions.frame = CGRectMake(
                                                 TNWidthCell / TNNumberBackgroundButtons - sizeDelimiter.width / 2.0f,
                                                 TNHeightBackgroundUser + TNMarginBackgroundButtons + TNMarginGeneral,
                                                 sizeDelimiter.width,
                                                 sizeDelimiter.height
                                             );
    delimiterSubscriptions.image = imageDelimiter;
    [self.delimiters addObject:delimiterSubscriptions];
    [self addSubview:delimiterSubscriptions];
    
    // Subscribers
    self.labelUserSubscribersCount = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelUserSubscribersCount.frame = CGRectMake(
                                                         TNWidthCell / TNNumberBackgroundButtons,
                                                         TNHeightBackgroundUser + TNMarginBackgroundButtons + TNMarginGeneral,
                                                         TNWidthCell / TNNumberBackgroundButtons,
                                                         TNHeightText
                                                     );
    self.labelUserSubscribersCount.shadowColor = [UIColor whiteColor];
    self.labelUserSubscribersCount.shadowOffset = CGSizeMake(0.0f, 1.5f);
    self.labelUserSubscribersCount.text = user.subscribersCount.stringValue;
    self.labelUserSubscribersCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelUserSubscribersCount];
    
    
    self.labelUserSubscribersTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelUserSubscribersTitle.frame = CGRectMake(
                                                         TNWidthCell / TNNumberBackgroundButtons,
                                                         CGRectGetMaxY(self.labelUserSubscribersCount.frame) + TNMarginGeneral,
                                                         TNWidthCell / TNNumberBackgroundButtons,
                                                         TNHeightText
                                                     );
    self.labelUserSubscribersTitle.shadowColor = [UIColor whiteColor];
    self.labelUserSubscribersTitle.shadowOffset = CGSizeMake(0.0f, 1.5f);
    self.labelUserSubscribersTitle.text = NSLocalizedString(@"Subscribers", nil);
    self.labelUserSubscribersTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelUserSubscribersTitle];
    
    UIImageView *delimiterSubscribers = [[UIImageView alloc] init];
    delimiterSubscribers.frame = CGRectMake(
                                               (TNWidthCell / TNNumberBackgroundButtons) * 2.0f - sizeDelimiter.width / 2.0f,
                                               TNHeightBackgroundUser + TNMarginBackgroundButtons + TNMarginGeneral,
                                               sizeDelimiter.width,
                                               sizeDelimiter.height
                                           );
    delimiterSubscribers.image = imageDelimiter;
    [self.delimiters addObject:delimiterSubscribers];
    [self addSubview:delimiterSubscribers];
    
    // Awards
    self.labelUserAwardsCount = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelUserAwardsCount.frame = CGRectMake(
                                                    (TNWidthCell / TNNumberBackgroundButtons) * 2.0f,
                                                    TNHeightBackgroundUser + TNMarginBackgroundButtons + TNMarginGeneral,
                                                    TNWidthCell / TNNumberBackgroundButtons,
                                                    TNHeightText
                                                );
    self.labelUserAwardsCount.shadowColor = [UIColor whiteColor];
    self.labelUserAwardsCount.shadowOffset = CGSizeMake(0.0f, 1.5f);
    self.labelUserAwardsCount.text = user.badgesCount.stringValue;
    self.labelUserAwardsCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelUserAwardsCount];
    
    
    self.labelUserAwardsTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelUserAwardsTitle.frame = CGRectMake(
                                                    (TNWidthCell / TNNumberBackgroundButtons) * 2.0f,
                                                    CGRectGetMaxY(self.labelUserAwardsCount.frame) + TNMarginGeneral,
                                                    TNWidthCell / TNNumberBackgroundButtons,
                                                    TNHeightText
                                                );
    self.labelUserAwardsTitle.shadowColor = [UIColor whiteColor];
    self.labelUserAwardsTitle.shadowOffset = CGSizeMake(0.0f, 1.5f);
    self.labelUserAwardsTitle.text = NSLocalizedString(@"Awards number", nil);
    self.labelUserAwardsTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelUserAwardsTitle];
    
    BOOL loginedUser = [user isEqualToUser:[[ObjectManager sharedManager] loginedUser]];
    if (!loginedUser)
    {
        self.submodel = user;
        [self displaySubscribedForObject:user];
        self.labelUserName.frame = CGRectSetWidth(
                                                     self.labelUserName.frame,
                                                     CGRectGetWidth(self.labelUserName.frame) - CGRectGetWidth(self.buttonSubscribe.frame) - TNMarginGeneral
                                                 );
    }
    
    CGRect frameButtonSubscriptions = CGRectMake(
                                                    0.0f,
                                                    TNHeightBackgroundUser,
                                                    TNWidthCell / TNNumberBackgroundButtons,
                                                    TNHeightBackgroundButtons
                                                );
    
    UserDetailsModel *userDetailsSubscriptions = [UserDetailsModel detailsWithUser:self.user type:UserDetailsTypeSubscriptions];
    [self placeButtonForObject:userDetailsSubscriptions frame:frameButtonSubscriptions];
    
    CGRect frameButtonSubscribers = CGRectMake(
                                                  TNWidthCell / TNNumberBackgroundButtons,
                                                  TNHeightBackgroundUser,
                                                  TNWidthCell / TNNumberBackgroundButtons,
                                                  TNHeightBackgroundButtons
                                              );
    UserDetailsModel *userDetailsSubscribers = [UserDetailsModel detailsWithUser:self.user type:UserDetailsTypeSubscribers];
    [self placeButtonForObject:userDetailsSubscribers frame:frameButtonSubscribers];
    
    CGRect frameButtonAwards = CGRectMake(
                                             (TNWidthCell / TNNumberBackgroundButtons) * 2.0f,
                                             TNHeightBackgroundUser,
                                             TNWidthCell / TNNumberBackgroundButtons,
                                             TNHeightBackgroundButtons
                                         );
    UserDetailsModel *userDetailsAwards = [UserDetailsModel detailsWithUser:self.user type:UserDetailsTypeAwards];
    [self placeButtonForObject:userDetailsAwards frame:frameButtonAwards];
    
    self.labelUserActivity = [UILabel labelSmallBold:YES black:YES];
    self.labelUserActivity.frame = CGRectMake(
                                                 TNMarginGeneral,
                                                 TNHeightBackgroundUser + TNHeightBackgroundButtons + TNHeightText,
                                                 TNWidthCell - TNMarginGeneral,
                                                 TNHeightText
                                             );
    self.labelUserActivity.text = NSLocalizedString(@"Activities", nil);
    [self addSubview:self.labelUserActivity];
    
    self.usedHeight = CGRectGetMaxY(self.labelUserActivity.frame) - TNMarginGeneral;
}

- (void)loadWithStake:(StakeModel *)stake
{
    BOOL loginedUser = [stake.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]];
    if (!loginedUser)
    {
        self.user = stake.user;
        [self displayUser:stake.user message:nil final:NO];
    }
    self.event = stake.event;
    self.tournament = stake.event.tournament;
    [self displayTournament:stake.event.tournament arrow:YES final:NO];
    if (![PuntrUtilities isEventVisible])
    {
        [self displayCategory:stake.event.tournament.category];
        [self displayParticipants:stake.event.participants final:NO];
    }
    if (loginedUser)
    {
        [self displayLine:stake.line
               components:stake.line.components
              coefficient:stake.coefficient
                    final:NO];
        [self displayStakeStatus:stake.status
                           money:stake.money
                     coefficient:stake.coefficient
                           final:YES];
    }
    else
    {
        [self displayLine:stake.line
               components:stake.line.components
              coefficient:stake.coefficient
                    final:YES];
    }

}

- (void)loadWithSubscription:(SubscriptionModel *)subscription
{
    [self blackCell];
    if (subscription.participant)
    {
        self.participant = subscription.participant;
        self.submodel = self.participant;
        [self displaySubscribedForObject:self.participant];
        [self displayParticipant:self.participant final:YES];
    }
    else if (subscription.event)
    {
        self.event = subscription.event;
        self.submodel = subscription.event;
        self.tournament = subscription.event.tournament;
        [self displaySubscribedForObject:self.submodel];
        [self displayCategory:subscription.event.tournament.category];
        [self displayParticipants:subscription.event.participants final:NO];
        [self displayStartTime:subscription.event.startTime endTime:subscription.event.endTime stakesCount:subscription.event.stakesCount final:YES];
    }
    else if (subscription.tournament)
    {
        [self loadWithTournament:subscription.tournament];
    }
    else if (subscription.user)
    {
        self.user = subscription.user;
        self.submodel = subscription.user;
        BOOL loginedUser = [self.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]];
        if (!loginedUser)
        {
            [self displaySubscribedForObject:self.submodel];
        }
        [self displayUser:self.submodel message:nil final:YES];
    }
}

- (void)loadWithSwitch:(SwitchModel *)switchModel
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[switchModel.firstTitle, switchModel.secondTitle]];
    self.segmentedControl.frame = CGRectMake(
                                                TNMarginGeneral,
                                                0.0f,
                                                TNWidthCell - TNMarginGeneral * 2.0f,
                                                TNHeightButton
                                            );
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor blackColor];
    [self.segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentedControl];
    self.usedHeight = CGRectGetMaxY(self.segmentedControl.frame) - TNMarginGeneral;
    dispatch_async(dispatch_get_main_queue(), ^
                      {
                          self.segmentedControl.selectedSegmentIndex = switchModel.firstOn ? 0 : 1;
                      }
                  );
}

- (void)loadWithTournament:(TournamentModel *)tournament
{
    self.tournament = tournament;
    self.submodel = tournament;
    if (tournament.banner) {
        [self displayBanner:tournament.banner];
    }
    [self displaySubscribedForObject:self.submodel];
    [self displayCategory:tournament.category];
    [self displayTournament:tournament arrow:NO final:NO];
    [self displayStartTime:tournament.startTime endTime:tournament.endTime stakesCount:tournament.stakesCount final:YES];
}

- (void)loadWithUser:(UserModel *)user
{
    CGFloat avatarWidth = 0.0f;
    
    // Background User
    
    self.userBackgroundProfile = [[UIView alloc] init];
    self.userBackgroundProfile.frame = CGRectMake(
                                                     0.0f,
                                                     0.0f,
                                                     TNWidthCell,
                                                     TNSideImageLarge + TNMarginGeneral * 2.0f
                                                 );
    self.userBackgroundProfile.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [self addSubview:self.userBackgroundProfile];
    
    // Avatar
    if (user.avatar)
    {
        self.imageViewUserAvatar = [[UIImageView alloc] init];
        self.imageViewUserAvatar.frame = CGRectMake(
                                                       TNMarginGeneral,
                                                       TNMarginGeneral,
                                                       TNSideImageLarge,
                                                       TNSideImageLarge
                                                   );
        [self.imageViewUserAvatar imageWithUrl:[user.avatar URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
        [self roundCornersForView:self.imageViewUserAvatar];
        [self addSubview:self.imageViewUserAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewUserAvatar.frame) + TNMarginGeneral;
    }
    
    CGFloat TNWidthLabel = TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth;
    
    // Name
    self.labelUserName = [UILabel labelSmallBold:YES black:YES];
    self.labelUserName.frame = CGRectMake(
                                             avatarWidth + TNMarginGeneral,
                                             TNMarginGeneral,
                                             TNWidthLabel,
                                             TNHeightText
                                         );
    self.labelUserName.text = [self nameFromUser:user];
    [self addSubview:self.labelUserName];
    
    // Top Position
    self.labelUserTopPosition = [UILabel labelSmallBold:YES black:YES];
    self.labelUserTopPosition.frame = CGRectMake(
                                                    avatarWidth + TNMarginGeneral,
                                                    CGRectGetMaxY(self.labelUserName.frame) + TNHeightText,
                                                    TNWidthLabel,
                                                    TNHeightText
                                                );
    self.labelUserTopPosition.text = [NSString stringWithFormat:@"ROI: %@", user.rating.stringValue];
    [self addSubview:self.labelUserTopPosition];
    
    [self roundCornersForView:self.userBackgroundProfile];
    
    BOOL loginedUser = [user isEqualToUser:[[ObjectManager sharedManager] loginedUser]];
    if (!loginedUser)
    {
        self.submodel = user;
        [self displaySubscribedForObject:user];
        self.labelUserName.frame = CGRectSetWidth(
                                                     self.labelUserName.frame,
                                                     CGRectGetWidth(self.labelUserName.frame) - CGRectGetWidth(self.buttonSubscribe.frame) - TNMarginGeneral
                                                 );
    }
    
    CGFloat maxY = CGRectGetMaxY(self.userBackgroundProfile.frame);
    
    [self placeButtonForObject:user maxY:maxY];
    
    self.usedHeight = maxY - TNMarginGeneral;
}

#pragma mark - Lead Components

- (void)blackCell
{
    self.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    self.blackBackground = YES;
}

- (void)displayArrow
{
    self.imageViewTournamentArrow = [[UIImageView alloc] init];
    CGFloat marginTime = self.labelActivityCreatedAt && self.delimiters.count == 0 ? [self.labelActivityCreatedAt sizeThatFits:self.labelActivityCreatedAt.frame.size].width + TNMarginGeneral : 0.0f;
    const CGSize TNSizeTournamentArrow = CGSizeMake(7.0f, 11.0f);
    self.imageViewTournamentArrow.frame = CGRectMake(
                                                     TNWidthCell - TNSizeTournamentArrow.width - TNMarginGeneral - marginTime,
                                                     self.usedHeight - TNSizeTournamentArrow.height,
                                                     TNSizeTournamentArrow.width,
                                                     TNSizeTournamentArrow.height
                                                     );
    self.imageViewTournamentArrow.image = [UIImage imageNamed:@"IconArrow"];
    [self addSubview:self.imageViewTournamentArrow];
}

- (void)displayAward:(AwardModel *)award
{
    [self roundCornersForView:self];
    
    self.labelAwardTitle = [UILabel labelSmallBold:YES black:YES];
    self.labelAwardTitle.numberOfLines = 0;
    self.labelAwardTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelAwardTitle.contentMode = UIViewContentModeCenter;
    self.labelAwardTitle.textAlignment = NSTextAlignmentCenter;
    self.labelAwardTitle.text = award.title;
    self.labelAwardTitle.backgroundColor = [UIColor clearColor];
    CGFloat labelWidth = TNSideBadge;
    CGSize textSize = [award.title sizeWithFont:self.labelAwardTitle.font constrainedToSize:CGSizeMake(labelWidth, labelWidth) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelY = TNSideBadge - (textSize.height) - (TNMarginGeneral / 2);
    self.labelAwardTitle.frame = CGRectMake(0.0f, labelY, labelWidth, textSize.height);
    [self addSubview:self.labelAwardTitle];
    
    CGFloat awardImageSide = CGRectGetMinY(self.labelAwardTitle.frame) - TNMarginGeneral;
    CGSize awardImageSize = CGSizeMake(awardImageSide, awardImageSide);
    CGFloat awardImageX = (TNSideBadge - awardImageSide) / 2;
    self.imageViewAward = [[UIImageView alloc] initWithFrame:CGRectMake(awardImageX, TNMarginGeneral, awardImageSize.height, awardImageSize.width)];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[award.image URLByAppendingSize:awardImageSize]];
    __weak LeadCell *weakSelf = self;
    [self.imageViewAward setImageWithURLRequest:urlRequest
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.imageViewAward.image = image;
                                            weakSelf.imageViewAward.contentMode = UIViewContentModeScaleToFill;
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            nil;
                                        }];
    self.imageViewAward.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageViewAward];
}

- (void)displayBackgroundForStake:(StakeModel *)stake
{
    if ([stake.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]])
    {
        [self blackCell];
    }
    else
    {
        [self blackCell];
    }
}

- (void)displayBanner:(NSURL *)banner
{
    CGSize sizeBanner = CGSizeMake(TNWidthCell, TNSideImageLarge);
    self.imageViewBanner = [[UIImageView alloc] init];
    self.imageViewBanner.frame = CGRectMake(
                                               0.0f,
                                               self.usedHeight,
                                               sizeBanner.width,
                                               sizeBanner.height
                                           );
    [self.imageViewBanner imageWithUrl:[banner URLByAppendingSize:sizeBanner]];
    [self addSubview:self.imageViewBanner];
    
    [self placeButtonForObject:[self tournamentOrEvent] frame:self.imageViewBanner.frame];
    
    self.usedHeight = CGRectGetMaxY(self.imageViewBanner.frame);
}

- (void)displayButtonBet
{
    self.buttonBet = [LeadButton buttonWithType:UIButtonTypeCustom];
    self.buttonBet.frame = CGRectMake(
                                         TNWidthCell - TNMarginGeneral - TNWidthButtonSmall,
                                         self.usedHeight + TNMarginGeneral,
                                         TNWidthButtonSmall,
                                         TNHeightButton
                                     );
    [self.buttonBet.titleLabel setFont:TNFontSmallBold];
    self.buttonBet.titleLabel.shadowColor = [UIColor blackColor];
    self.buttonBet.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonBet.titleLabel setTextColor:[UIColor whiteColor]];
    [self.buttonBet setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)]
                                     forState:UIControlStateNormal];
    [self.buttonBet setTitle:NSLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
    if ([ObjectManager sharedManager].authorized)
    {
        [self.buttonBet addTarget:self action:@selector(buttonBetTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.buttonBet addTarget:[NotificationManager class] action:@selector(unauthorized) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.buttonBet];
}

- (void)displayButtonStake
{
    self.buttonEventStake = [LeadButton buttonWithType:UIButtonTypeCustom];
    self.buttonEventStake.frame = CGRectMake(
                                             TNWidthCell - TNMarginGeneral - TNWidthButtonSmall,
                                             self.usedHeight + TNMarginGeneral,
                                             TNWidthButtonSmall,
                                             TNHeightButton
                                             );
    [self.buttonEventStake.titleLabel setFont:TNFontSmallBold];
    self.buttonEventStake.titleLabel.shadowColor = [UIColor colorWithRed:0.25f green:0.46f blue:0.04f alpha:1.00f];
    self.buttonEventStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonEventStake.titleLabel setTextColor:[UIColor whiteColor]];
    [self.buttonEventStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreenSmall"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)]
                                     forState:UIControlStateNormal];
    [self.buttonEventStake setTitle:NSLocalizedString(@"Stake", nil) forState:UIControlStateNormal];
    StakeModel *stake = [[StakeModel alloc] init];
    stake.event = self.event;
    self.buttonEventStake.model = stake;
    if ([ObjectManager sharedManager].authorized)
    {
        [self.buttonEventStake addTarget:self action:@selector(buttonLeadTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.buttonEventStake addTarget:[NotificationManager class] action:@selector(unauthorized) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addSubview:self.buttonEventStake];
}

- (void)displayButtonsEventFinal:(BOOL)final
{
    CGFloat TNMarginButtons = TNMarginGeneral + 1.0f;
    
    self.buttonEventBet = [LeadButton buttonWithType:UIButtonTypeCustom];
    self.buttonEventBet.frame = CGRectMake(
                                              TNMarginButtons,
                                              self.usedHeight + TNMarginGeneral,
                                              TNWidthButtonLarge,
                                              TNHeightButton
                                          );
    [self.buttonEventBet.titleLabel setFont:TNFontSmallBold];
    self.buttonEventBet.titleLabel.shadowColor = [UIColor blackColor];
    self.buttonEventBet.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonEventBet.titleLabel setTextColor:[UIColor whiteColor]];
    [self.buttonEventBet setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [self.buttonEventBet setTitle:NSLocalizedString(@"Bet", nil) forState:UIControlStateNormal];
    BetModel *bet = [[BetModel alloc] init];
    bet.event = self.event;
    self.buttonEventBet.model = bet;
    if ([ObjectManager sharedManager].authorized)
    {
        [self.buttonEventBet addTarget:self action:@selector(buttonLeadTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.buttonEventBet addTarget:[NotificationManager class] action:@selector(unauthorized) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.buttonEventBet];
    
    
    CGFloat delimiterWidth = 1.0f;
    UIImage *delimiterImageSource = [UIImage imageNamed:@"leadDelimiter"];
    UIImage *delimiterImageOrient = [[UIImage alloc] initWithCGImage:delimiterImageSource.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    UIImage *delimiterImage = [delimiterImageOrient resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    if (self.blackBackground)
    {
        delimiterImage = [[UIImage imageNamed:@"delimiterBlack"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
    
    UIImageView *imageViewDelimiterFirst = [[UIImageView alloc] init];
    imageViewDelimiterFirst.frame = CGRectMake(
                                                  TNMarginButtons + TNWidthButtonLarge + TNMarginButtons,
                                                  self.usedHeight,
                                                  delimiterWidth,
                                                  TNMarginGeneral + TNHeightButton + TNMarginGeneral
                                              );
    imageViewDelimiterFirst.image = delimiterImage;
    [self.delimiters addObject:imageViewDelimiterFirst];
    [self addSubview:imageViewDelimiterFirst];
    
    self.buttonEventStake = [LeadButton buttonWithType:UIButtonTypeCustom];
    self.buttonEventStake.frame = CGRectMake(
                                                CGRectGetMaxX(imageViewDelimiterFirst.frame) + TNMarginButtons,
                                                self.usedHeight + TNMarginGeneral,
                                                TNWidthButtonSmall,
                                                TNHeightButton
                                            );
    [self.buttonEventStake.titleLabel setFont:TNFontSmallBold];
    self.buttonEventStake.titleLabel.shadowColor = [UIColor colorWithRed:0.25f green:0.46f blue:0.04f alpha:1.00f];
    self.buttonEventStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonEventStake.titleLabel setTextColor:[UIColor whiteColor]];
    [self.buttonEventStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreenSmall"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)]
                                     forState:UIControlStateNormal];
    [self.buttonEventStake setTitle:NSLocalizedString(@"Stake", nil) forState:UIControlStateNormal];
    StakeModel *stake = [[StakeModel alloc] init];
    stake.event = self.event;
    self.buttonEventStake.model = stake;
    if ([ObjectManager sharedManager].authorized)
    {
        [self.buttonEventStake addTarget:self action:@selector(buttonLeadTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.buttonEventStake addTarget:[NotificationManager class] action:@selector(unauthorized) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.buttonEventStake];
    
    if ([self.event.endTime isEqualToDate:[self.event.endTime earlierDate:[NSDate date]]])
    {
        self.buttonEventBet.enabled = NO;
        self.buttonEventStake.enabled = NO;
    }
    
    UIImageView *imageViewDelimiterSecond = [[UIImageView alloc] init];
    imageViewDelimiterSecond.frame = CGRectMake(
                                                   CGRectGetMaxX(self.buttonEventStake.frame) + TNMarginButtons,
                                                   self.usedHeight,
                                                   delimiterWidth,
                                                   TNMarginGeneral + TNHeightButton + TNMarginGeneral
                                               );
    imageViewDelimiterSecond.image = delimiterImage;
    [self.delimiters addObject:imageViewDelimiterSecond];
    [self addSubview:imageViewDelimiterSecond];
    
    [self displaySubscribedForObject:self.event];
    
    self.usedHeight = CGRectGetMaxY(self.buttonEventBet.frame);
    
    [self makeFinal:final];
}

- (void)displayCategory:(CategoryModel *)category
{
    CGFloat categoryImageWidth = 0.0f;
    CGSize categoryImageSize = CGSizeMake(12.0f, 12.0f);
    
    CGFloat TNMarginCategoryImage = 7.0f;
    
    if (category.image)
    {
        self.imageViewCategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                       TNMarginGeneral,
                                                                                       self.usedHeight + TNMarginCategoryImage,
                                                                                       categoryImageSize.width,
                                                                                       categoryImageSize.height
                                                                                   )];
        [self.imageViewCategoryImage imageWithUrl:[category.image URLByAppendingSize:categoryImageSize]];
        [self addSubview:self.imageViewCategoryImage];
        
        categoryImageWidth = CGRectGetMaxX(self.imageViewCategoryImage.frame);
    }
    
    CGFloat TNMarginCategoryTitle = 4.0f;
    
    self.labelCategoryTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelCategoryTitle.frame = CGRectMake(
                                               TNMarginCategoryTitle + categoryImageWidth,
                                               self.usedHeight + TNMarginGeneral,
                                               TNWidthCell - TNMarginGeneral * 2.0f - categoryImageWidth,
                                               TNHeightText
                                               );
    self.labelCategoryTitle.text = category.title;
    [self addSubview:self.labelCategoryTitle];
    
    CGFloat maxY = CGRectGetMaxY(self.labelCategoryTitle.frame);
    [self placeButtonForObject:[self tournamentOrEvent] maxY:maxY];
    
    self.usedHeight = maxY;
}

- (void)displayCreator:(UserModel *)creator opponent:(UserModel *)opponent final:(BOOL)final
{
    CGFloat widthAvatarCreator = 0.0f;
    CGFloat sideSwords = 21.0f;
    
    if (creator.avatar)
    {
        self.imageViewBetAvatarCreator = [[UIImageView alloc] init];
        self.imageViewBetAvatarCreator.frame = CGRectMake(
                                                             TNMarginGeneral,
                                                             self.usedHeight + TNMarginGeneral,
                                                             TNSideImage,
                                                             TNSideImage
                                                         );
        [self.imageViewBetAvatarCreator imageWithUrl:[creator.avatar URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
        [self roundCornersForView:self.imageViewBetAvatarCreator];
        [self addSubview:self.imageViewBetAvatarCreator];
        
        widthAvatarCreator = CGRectGetWidth(self.imageViewBetAvatarCreator.frame) + TNMarginGeneral;
    }
    
    self.labelBetNameCreator = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelBetNameCreator.frame = CGRectMake(
                                                   TNMarginGeneral + widthAvatarCreator,
                                                   self.usedHeight + TNMarginGeneral,
                                                   TNWidthCell / 2.0f - TNMarginGeneral + widthAvatarCreator - sideSwords,
                                                   TNSideImage
                                               );
    self.labelBetNameCreator.textAlignment = NSTextAlignmentLeft;
    self.labelBetNameCreator.text = [self nameFromUser:creator];
    [self addSubview:self.labelBetNameCreator];
    
    [self placeButtonForObject:creator frame:CGRectMake(
                                                           0.0f,
                                                           self.usedHeight,
                                                           TNWidthCell / 2.0f,
                                                           TNSideImage + TNMarginGeneral * 2.0f
                                                       )];
    
    if (self.bet.accepted.boolValue)
    {
        self.imageViewBetSwords = [[UIImageView alloc] init];
        self.imageViewBetSwords.frame = CGRectMake(
                                                      TNWidthCell / 2.0f - floorf(sideSwords / 2.0f),
                                                      self.usedHeight + TNMarginGeneral + (TNSideImage / 2.0f - floorf(sideSwords / 2.0f)),
                                                      sideSwords,
                                                      sideSwords
                                                  );
        self.imageViewBetSwords.image = [UIImage imageNamed:@"IconPari"];
        [self addSubview:self.imageViewBetSwords];
        
        CGFloat widthAvatarOpponent = 0.0f;
        
        if (opponent.avatar)
        {
            self.imageViewBetAvatarOpponent = [[UIImageView alloc] init];
            self.imageViewBetAvatarOpponent.frame = CGRectMake(
                                                                  TNWidthCell - TNMarginGeneral - TNSideImage,
                                                                  self.usedHeight + TNMarginGeneral,
                                                                  TNSideImage,
                                                                  TNSideImage
                                                              );
            [self.imageViewBetAvatarOpponent imageWithUrl:[opponent.avatar URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
            [self roundCornersForView:self.imageViewBetAvatarOpponent];
            [self addSubview:self.imageViewBetAvatarOpponent];
            
            widthAvatarOpponent = CGRectGetWidth(self.imageViewBetAvatarOpponent.frame) + TNMarginGeneral;
        }
        
        self.labelBetNameOpponent = [UILabel labelSmallBold:YES black:self.blackBackground];
        self.labelBetNameOpponent.frame = CGRectMake(
                                                        TNWidthCell / 2.0f + sideSwords,
                                                        self.usedHeight + TNMarginGeneral,
                                                        TNWidthCell / 2.0f - sideSwords - TNMarginGeneral - widthAvatarCreator,
                                                        TNSideImage
                                                    );
        self.labelBetNameOpponent.textAlignment = NSTextAlignmentRight;
        self.labelBetNameOpponent.text = [self nameFromUser:opponent];
        [self addSubview:self.labelBetNameOpponent];
        
        [self placeButtonForObject:creator frame:CGRectMake(
                                                               TNWidthCell / 2.0f,
                                                               self.usedHeight,
                                                               TNWidthCell / 2.0f,
                                                               TNSideImage + TNMarginGeneral * 2.0f
                                                           )];
    }
    else
    {
        UserModel *loginedUser = [[ObjectManager sharedManager] loginedUser];
        BOOL isOpponent = [opponent isEqualToUser:loginedUser];
        if (isOpponent)
        {
            [self displayButtonBet];
        }
    }
    
    self.usedHeight = CGRectGetMaxY(self.labelBetNameCreator.frame);
    
    [self makeFinal:final];
}

- (void)displayDynamicSelection:(DynamicSelectionModel *)dynamicSelection
{
    self.switchDynamicSelection = [[UISwitch alloc] initWithFrame:CGRectMake(
                                                                             TNWidthCell - TNMarginGeneral - TNWidthSwitch,
                                                                             TNMarginGeneral,
                                                                             TNWidthSwitch,
                                                                             TNHeightSwitch
                                                                            )];
    [self.switchDynamicSelection setOn:dynamicSelection.status.boolValue animated:NO];
    [self.switchDynamicSelection addTarget:self action:@selector(touchedSwitchDynamicSelection) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.switchDynamicSelection];
    
    self.labelDynamicSelectionTitle = [UILabel labelSmallBold:YES black:YES];
    self.labelDynamicSelectionTitle.frame = CGRectMake(
                                                       TNMarginGeneral,
                                                       TNMarginGeneral,
                                                       CGRectGetMinX(self.switchDynamicSelection.frame) - TNMarginGeneral,
                                                       TNHeightText
                                                      );
    self.labelDynamicSelectionTitle.text = dynamicSelection.title;
    [self addSubview:self.labelDynamicSelectionTitle];
    if(dynamicSelection.description != nil)
    {
        self.labelDynamicSelectionDescription = [UILabel labelSmallBold:NO black:YES];
        CGSize descriptionSize = [dynamicSelection.description sizeWithFont:self.labelDynamicSelectionDescription.font forWidth:TNWidthCell - TNMarginGeneral * 2.0f lineBreakMode:NSLineBreakByWordWrapping];
        self.labelDynamicSelectionDescription.frame = CGRectMake(
                                                                 TNMarginGeneral,
                                                                 CGRectGetMaxY(self.switchDynamicSelection.frame) + TNMarginGeneral,
                                                                 descriptionSize.width,
                                                                 descriptionSize.height
                                                                 );
        
        self.labelDynamicSelectionDescription.text = dynamicSelection.description;
        [self.labelDynamicSelectionDescription setNumberOfLines:0];
        [self.labelDynamicSelectionDescription setLineBreakMode:NSLineBreakByWordWrapping];
        [self.labelDynamicSelectionDescription sizeToFit];
        [self addSubview:self.labelDynamicSelectionDescription];
        
        self.usedHeight = CGRectGetMaxY(self.labelDynamicSelectionDescription.frame);
    }
    else
    {
        
        self.labelDynamicSelectionTitle.frame = CGRectMake(
                                                           TNMarginGeneral,
                                                           CGRectGetMinY(self.switchDynamicSelection.frame) + (CGRectGetHeight(self.switchDynamicSelection.frame) - TNHeightText)/2,
                                                           CGRectGetMinX(self.switchDynamicSelection.frame) - TNMarginGeneral,
                                                           TNHeightText
                                                           );
        self.usedHeight = CGRectGetMaxY(self.switchDynamicSelection.frame);
    }
    
    
    [self makeFinal:YES];
    
}

- (void)displayGroup:(GroupModel *)group final:(BOOL)final
{
    CGFloat TNGroupHeight = 40.0f;
    CGFloat TNGroupImageMargin = (TNGroupHeight - TNSideImageMedium) / 2.0f;
    CGFloat TNGroupTitleMargin = (TNGroupHeight - TNHeightText) / 2.0f;
    
    BOOL hasImage = group.image || group.imageHardcode ? YES : NO;
    if (hasImage)
    {
        self.imageViewGroupImage = [[UIImageView alloc] init];
        self.imageViewGroupImage.frame = CGRectMake(
                                                       TNGroupImageMargin,
                                                       TNGroupImageMargin,
                                                       TNSideImageMedium,
                                                       TNSideImageMedium
                                                   );
        if (group.image)
        {
            [self.imageViewGroupImage imageWithUrl:group.image];
        }
        else
        {
            self.imageViewGroupImage.image = group.imageHardcode;
        }
        [self addSubview:self.imageViewGroupImage];
    }
    
    CGFloat TNGroupTitleMarginLeft = hasImage ? TNGroupImageMargin * 2.0f + TNSideImageMedium : TNGroupImageMargin;
    self.labelGroupTitle = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelGroupTitle.frame = CGRectMake(
                                               TNGroupTitleMarginLeft,
                                               TNGroupTitleMargin,
                                               TNWidthCell - TNGroupTitleMarginLeft - TNMarginGeneral,
                                               TNHeightText
                                           );
    self.labelGroupTitle.text = group.title;
    [self addSubview:self.labelGroupTitle];
    
    self.usedHeight = CGRectGetMaxY(self.labelGroupTitle.frame);
    
    [self displayArrow];
    
    self.usedHeight += TNGroupTitleMargin - TNMarginGeneral;
    
    CGRect frameGroup = CGRectMake(0.0f, 0.0f, TNWidthCell, self.usedHeight + TNMarginGeneral);
    [self placeButtonForObject:self.group frame:frameGroup];
    
    [self makeFinal:final];
}

- (void)displayLine:(LineModel *)line
         components:(NSArray *)components
        coefficient:(CoefficientModel *)coefficient
              final:(BOOL)final
{
    CGFloat widthMoney = 0.0f;
    if (!coefficient)
    {
        self.labelCoefficientValue = [UILabel labelSmallBold:YES black:self.blackBackground];
        self.labelCoefficientValue.frame = CGRectMake(
                                                         TNMarginGeneral,
                                                         self.usedHeight + TNMarginGeneral,
                                                         TNWidthCell - TNMarginGeneral * 2.0f,
                                                         TNHeightText
                                                     );
        self.labelCoefficientValue.text = [NSString stringWithFormat:@"+%@", self.bet.money.amount.stringValue];
        [self.labelCoefficientValue sizeToFit];
        [self addSubview:self.labelCoefficientValue];
        widthMoney = TNMarginGeneral + CGRectGetWidth(self.labelCoefficientValue.frame);
    }
    
    // Line
    self.labelLineTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelLineTitle.frame = CGRectMake(
                                               TNMarginGeneral + widthMoney,
                                               self.usedHeight + TNMarginGeneral,
                                               TNWidthCell - TNMarginGeneral * 2.0f,
                                               TNHeightText
                                          );
    NSString *capitalisedLine = [[line.title lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                      withString:[[line.title  substringToIndex:1] capitalizedString]];
    self.labelLineTitle.text = [NSString stringWithFormat:@"%@:", capitalisedLine];
    [self.labelLineTitle sizeToFit];
    [self addSubview:self.labelLineTitle];
    
    // Components
    self.labelComponentCombined = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelComponentCombined.frame = CGRectMake(
                                                CGRectGetMaxX(self.labelLineTitle.frame) + TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                TNWidthCell - (CGRectGetMaxX(self.labelLineTitle.frame) + TNMarginGeneral * 3.0f),
                                                TNHeightText
                                           );
    NSMutableString *componentsCombined = [[NSMutableString alloc] init];
    for (ComponentModel *component in components)
    {
        [componentsCombined appendFormat:@"%@ ", component.selectedCriterionObject.title];
    }
    self.labelComponentCombined.text = [componentsCombined copy];
    [self.labelComponentCombined sizeToFit];
    [self addSubview:self.labelComponentCombined];
    
    // Coefficient
    if (coefficient)
    {
        NSNumberFormatter *twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
        [twoDecimalPlacesFormatter setMaximumFractionDigits:2];
        [twoDecimalPlacesFormatter setMinimumFractionDigits:0];
        NSString *coefficientString = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Odds", nil),[twoDecimalPlacesFormatter stringFromNumber:coefficient.value]];
        CGPoint coefficientOrigin = CGPointMake(TNMarginGeneral, CGRectGetMaxY(self.labelLineTitle.frame) + TNMarginGeneral);
        CGSize coefficientSize = [coefficientString sizeWithFont:TNFontSmall constrainedToSize:CGSizeMake(TNWidthCell - TNMarginGeneral * 2.0f, TNHeightText)];
        if (coefficientSize.width <= TNWidthCell - CGRectGetMaxX(self.labelComponentCombined.frame) - TNMarginGeneral * 2.0f)
        {
            coefficientOrigin = CGPointMake(
                                            CGRectGetMaxX(self.labelComponentCombined.frame) + TNMarginGeneral,
                                            self.usedHeight + TNMarginGeneral
                                           );
        }
        self.labelCoefficientValue = [UILabel labelSmallBold:NO black:self.blackBackground];
        self.labelCoefficientValue.frame = CGRectMake(
                                                 coefficientOrigin.x,
                                                 coefficientOrigin.y,
                                                 coefficientSize.width,
                                                 coefficientSize.height
                                                );
        self.labelCoefficientValue.text = coefficientString;
        [self addSubview:self.labelCoefficientValue];
        
        self.usedHeight = CGRectGetMaxY(self.labelCoefficientValue.frame);
    }
    else
    {
        self.usedHeight = CGRectGetMaxY(self.labelComponentCombined.frame);
    }
    
    [self makeFinal:final];
}

- (void)displayLoading
{
    CGFloat TNSideActivityIndicator = 20.0f;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(
                                                 (TNWidthCell - TNSideActivityIndicator) / 2.0f,
                                                 self.usedHeight + TNMarginGeneral,
                                                 TNSideActivityIndicator,
                                                 TNSideActivityIndicator
                                             );
    self.activityIndicator.color = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [self.activityIndicator startAnimating];
    [self addSubview:self.activityIndicator];
    
    self.usedHeight = CGRectGetMaxY(self.activityIndicator.frame);
}

- (void)displayParticipant:(ParticipantModel *)participant final:(BOOL)final
{
    CGFloat marginImage = 0.0f;
    if (participant.logo) {
        UIImageView *imageViewParticipantLogo = [[UIImageView alloc] init];
        imageViewParticipantLogo.frame = CGRectMake(
                                                    TNMarginGeneral,
                                                    self.usedHeight + TNMarginGeneral,
                                                    TNSideImage,
                                                    TNSideImage
                                                    );
        [imageViewParticipantLogo imageWithUrl:[participant.logo URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
        [self.participantLogos addObject:imageViewParticipantLogo];
        [self addSubview:imageViewParticipantLogo];
        marginImage = TNSideImage + TNMarginGeneral;
    }
    
    UILabel *labelParticipantTitle = [UILabel labelSmallBold:YES black:self.blackBackground];
    labelParticipantTitle.frame = CGRectMake(
                                             TNMarginGeneral + marginImage,
                                             self.usedHeight + TNMarginGeneral,
                                             TNWidthCell - (TNMarginGeneral + marginImage) - (TNMarginGeneral + CGRectGetWidth(self.buttonSubscribe.frame)),
                                             TNSideImage
                                             );
    labelParticipantTitle.text = participant.title;
    [self.participantTitles addObject:labelParticipantTitle];
    [self addSubview:labelParticipantTitle];
    
    CGFloat maxY = CGRectGetMaxY(labelParticipantTitle.frame);
    [self placeButtonForObject:self.participant maxY:maxY + TNMarginGeneral];
    
    self.usedHeight = maxY;
    
    [self makeFinal:final];
}

- (void)displayParticipants:(NSArray *)participants final:(BOOL)final
{
    // Participants
    NSUInteger participantsMAX = NSUIntegerMax;
    NSUInteger participantIndex = 0;
    for (ParticipantModel *participant in participants)
    {
        if (participantIndex < participantsMAX)
        {
            // Element Frames
            CGRect frameTitlePrevious = participantIndex == 0 ? CGRectZero : [self.participantTitles[participantIndex - 1] frame];
            
            CGRect frameButtonStake = self.buttonEventStake ? self.buttonEventStake.frame : CGRectZero;
            
            CGRect frameButtonSubscribe = self.buttonSubscribe ? self.buttonSubscribe.frame : CGRectZero;
            
            CGPoint originLogo = CGPointZero;
            CGSize sizeLogo = CGSizeZero;
            CGRect frameLogo = CGRectZero;
            
            CGPoint originTitle = CGPointZero;
            CGSize sizeTitle = CGSizeZero;
            CGRect frameTitle = CGRectZero;
            
            // Avaliable Width
            CGFloat margins = TNMarginGeneral * 2.0f;
            if (CGRectGetWidth(frameButtonStake) != 0 || CGRectGetWidth(frameButtonSubscribe) != 0)
            {
                margins += TNMarginGeneral;
            }
            CGFloat widthPreviouslyTaken = CGRectGetMaxX(frameTitlePrevious);
            CGFloat widthButton = 0.0f;
            if (CGRectGetWidth(frameButtonStake) != 0)
            {
                widthButton = CGRectGetWidth(frameButtonStake);
            }
            else if (CGRectGetWidth(frameButtonSubscribe) != 0)
            {
                widthButton = CGRectGetWidth(frameButtonSubscribe);
            }
            CGFloat widthAvaliable = TNWidthCell - widthPreviouslyTaken - margins - widthButton;
            
            // Needed Width
            CGFloat widthLogoNeeded = participant.logo ? TNSideImageSmall : 0.0f;
            NSUInteger participantIndexNext = participantIndex + 1;
            BOOL lastParticipant = participantIndexNext >= participantsMAX || participantIndexNext >= participants.count;
            NSString *stringTitleParticipant = lastParticipant ? participant.title : [NSString stringWithFormat:@"%@  —", participant.title];
            CGSize sizeTitleMax = CGSizeMake(TNWidthCell + 2.0f * TNMarginGeneral, TNHeightText);
            CGSize sizeTitleNeeded = [stringTitleParticipant sizeWithFont:TNFontSmallBold constrainedToSize:sizeTitleMax];
            CGFloat widthTitleNeeded = sizeTitleNeeded.width;
            CGFloat widthNeeded = widthLogoNeeded + TNMarginGeneral + widthTitleNeeded;
            
            // Used Height
            CGFloat heightUsed = self.usedHeight;
            if (CGRectGetHeight(frameTitlePrevious) != 0)
            {
                heightUsed = CGRectGetMaxY(frameTitlePrevious);
            }
            CGFloat yStart = heightUsed + TNMarginGeneral;
            if (CGRectGetHeight(frameTitlePrevious) != 0)
            {
                yStart = CGRectGetMinY(frameTitlePrevious);
            }
            
            if (widthAvaliable < widthNeeded)
            {
                if (participant.logo)
                {
                    originLogo = CGPointMake(TNMarginGeneral, heightUsed + TNMarginGeneral);
                    sizeLogo = CGSizeMake(TNSideImageSmall, TNSideImageSmall);
                    frameLogo = CGRectMake(originLogo.x, originLogo.y, sizeLogo.width, sizeLogo.height);
                    
                    originTitle = CGPointMake(CGRectGetMaxX(frameLogo) + TNMarginGeneral, heightUsed + TNMarginGeneral);
                    sizeTitle = CGSizeMake(widthTitleNeeded, TNHeightText);
                    frameTitle = CGRectMake(originTitle.x, originTitle.y, sizeTitle.width, sizeTitle.height);
                }
                else
                {
                    originTitle = CGPointMake(TNMarginGeneral, heightUsed + TNMarginGeneral);
                    sizeTitle = CGSizeMake(widthTitleNeeded, TNHeightText);
                    frameTitle = CGRectMake(originTitle.x, originTitle.y, sizeTitle.width, sizeTitle.height);
                }
            }
            else
            {
                if (participant.logo)
                {
                    originLogo = CGPointMake(widthPreviouslyTaken + TNMarginGeneral, yStart);
                    sizeLogo = CGSizeMake(TNSideImageSmall, TNSideImageSmall);
                    frameLogo = CGRectMake(originLogo.x, originLogo.y, sizeLogo.width, sizeLogo.height);
                    
                    originTitle = CGPointMake(CGRectGetMaxX(frameLogo) + TNMarginGeneral, yStart);
                    sizeTitle = CGSizeMake(widthTitleNeeded, TNHeightText);
                    frameTitle = CGRectMake(originTitle.x, originTitle.y, sizeTitle.width, sizeTitle.height);
                }
                else
                {
                    originTitle = CGPointMake(widthPreviouslyTaken + TNMarginGeneral, yStart);
                    sizeTitle = CGSizeMake(widthTitleNeeded, TNHeightText);
                    frameTitle = CGRectMake(originTitle.x, originTitle.y, sizeTitle.width, sizeTitle.height);
                }
            }
            
            if (participant.logo)
            {
                UIImageView *imageViewParticipantLogo = [[UIImageView alloc] init];
                imageViewParticipantLogo.frame = frameLogo;
                [imageViewParticipantLogo imageWithUrl:[participant.logo URLByAppendingSize:sizeLogo]];
                [self.participantLogos addObject:imageViewParticipantLogo];
                [self addSubview:imageViewParticipantLogo];
            }
            
            UILabel *labelParticipantTitle = [UILabel labelSmallBold:YES black:self.blackBackground];
            labelParticipantTitle.frame = frameTitle;
            labelParticipantTitle.text = stringTitleParticipant;
            [self.participantTitles addObject:labelParticipantTitle];
            [self addSubview:labelParticipantTitle];
        }
        
        participantIndex++;
    }
    
    CGFloat maxY = CGRectGetMaxY([self.participantTitles.lastObject frame]);
    [self placeButtonForObject:self.event maxY:maxY + TNMarginGeneral];
    
    self.usedHeight = maxY;
    
    [self makeFinal:final];
}

- (void)displayParticipantsMaster:(NSArray *)participants final:(BOOL)final
{
    ParticipantModel *participantFirst = participants[0];
    ParticipantModel *participantSecond = participants.count > 1 ? participants[1] : nil;
    CGFloat marginImageFirst = 0.0f;
    CGFloat widthLabelMax = 135.0f;
    CGFloat marginImage = TNSideImageLarge + TNMarginGeneral;
    if (participantFirst.logo)
    {
        UIImageView *imageViewParticipantLogoFirst = [[UIImageView alloc] init];
        imageViewParticipantLogoFirst.frame = CGRectMake(
                                                            TNMarginGeneral,
                                                            self.usedHeight + TNMarginGeneral,
                                                            TNSideImageLarge,
                                                            TNSideImageLarge
                                                        );
        [imageViewParticipantLogoFirst setImageWithURL:[participantFirst.logo URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
        [self roundCornersForView:imageViewParticipantLogoFirst];
        [self.participantLogos addObject:imageViewParticipantLogoFirst];
        [self addSubview:imageViewParticipantLogoFirst];
        marginImageFirst = marginImage;
    }
    
    UILabel *labelParticipantTitleFirst = [UILabel labelSmallBold:YES black:self.blackBackground];
    labelParticipantTitleFirst.frame = CGRectMake(
                                                     TNMarginGeneral + marginImageFirst,
                                                     self.usedHeight + TNMarginGeneral,
                                                     widthLabelMax - TNMarginGeneral - marginImageFirst,
                                                     TNSideImageLarge
                                                 );
    labelParticipantTitleFirst.text = participantFirst.title;
    labelParticipantTitleFirst.textAlignment = NSTextAlignmentRight;
    [self.participantTitles addObject:labelParticipantTitleFirst];
    [self addSubview:labelParticipantTitleFirst];
    
    if (self.event.status)
    {
        self.labelEventStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
        self.labelEventStatus.frame = CGRectMake(
                                                    widthLabelMax,
                                                    self.usedHeight + TNMarginGeneral,
                                                    TNWidthCell - widthLabelMax * 2.0f,
                                                    TNSideImageLarge
                                                );
        self.labelEventStatus.text = self.event.status;
        self.labelEventStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelEventStatus];
    }
    
    [self placeButtonForObject:participantFirst frame:CGRectMake(
                                                                    0.0f,
                                                                    self.usedHeight,
                                                                    widthLabelMax,
                                                                    TNSideImageLarge + TNMarginGeneral * 2.0f
                                                                )];
    
    if (participantSecond)
    {
        CGFloat marginImageSecond = 0.0f;
        if (participantSecond.logo)
        {
            UIImageView *imageViewParticipantLogoSecond = [[UIImageView alloc] init];
            imageViewParticipantLogoSecond.frame = CGRectMake(
                                                                 TNWidthCell - TNMarginGeneral - TNSideImageLarge,
                                                                 self.usedHeight + TNMarginGeneral,
                                                                 TNSideImageLarge,
                                                                 TNSideImageLarge
                                                             );
            [imageViewParticipantLogoSecond setImageWithURL:[participantSecond.logo URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
            [self roundCornersForView:imageViewParticipantLogoSecond];
            [self.participantLogos addObject:imageViewParticipantLogoSecond];
            [self addSubview:imageViewParticipantLogoSecond];
            marginImageSecond = marginImage;
        }
        
        UILabel *labelParticipantTitleSecond = [UILabel labelSmallBold:YES black:self.blackBackground];
        labelParticipantTitleSecond.frame = CGRectMake(
                                                          TNWidthCell - widthLabelMax,
                                                          self.usedHeight + TNMarginGeneral,
                                                          widthLabelMax - TNMarginGeneral - marginImageSecond,
                                                          TNSideImageLarge
                                                      );
        labelParticipantTitleSecond.text = participantSecond.title;
        labelParticipantTitleSecond.textAlignment = NSTextAlignmentLeft;
        [self.participantTitles addObject:labelParticipantTitleSecond];
        [self addSubview:labelParticipantTitleSecond];
        
        [self placeButtonForObject:participantSecond frame:CGRectMake(
                                                                         TNWidthCell - widthLabelMax,
                                                                         self.usedHeight,
                                                                         widthLabelMax,
                                                                         TNSideImageLarge + TNMarginGeneral * 2.0f
                                                                     )];
    }
    
    CGFloat maxY = self.usedHeight + TNMarginGeneral + TNSideImageLarge;
    
    self.usedHeight = maxY;
    
    [self makeFinal:final];
}

- (void)displayScore:(ScoreModel *)score
{
    CGFloat TNMarginTime = 25.0f;
    CGFloat TNMarginName = 128.0f;
    CGFloat TNMarginCategory = TNMarginGeneral;
    
    UILabel *labelTime = [UILabel labelSmallBold:NO black:self.blackBackground];
    labelTime.frame = CGRectMake(
                                    TNMarginGeneral,
                                    self.usedHeight + TNMarginGeneral,
                                    TNMarginTime - TNMarginGeneral,
                                    TNHeightText
                                );
    labelTime.text = [NSString stringWithFormat:@"%@'", score.time.stringValue];
    [self.scoreTimes addObject:labelTime];
    [self addSubview:labelTime];
    
    UILabel *labelStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
    labelStatus.frame = CGRectMake(
                                      TNMarginName,
                                      self.usedHeight + TNMarginGeneral,
                                      TNWidthCell - TNMarginName * 2.0f,
                                      TNHeightText
                                  );
    labelStatus.textAlignment = NSTextAlignmentCenter;
    labelStatus.text = score.status;
    [self.scoreStatuses addObject:labelStatus];
    [self addSubview:labelStatus];
    
    NSNumber *leftParticipantTag = [(ParticipantModel *)self.event.participants[0] tag];
    BOOL isLeft = [leftParticipantTag isEqualToNumber:score.participantTag];
    
    CGRect frameName;
    CGRect frameCategory;
    NSTextAlignment alignmentName;
    
    if (isLeft)
    {
        frameName = CGRectMake(
                                  TNMarginTime,
                                  self.usedHeight + TNMarginGeneral,
                                  TNMarginName - TNMarginTime - TNSideImageSmall - TNMarginCategory,
                                  TNHeightText
                              );
        alignmentName = NSTextAlignmentRight;
        frameCategory = CGRectMake(
                                      TNMarginName - TNSideImageSmall,
                                      self.usedHeight + TNMarginGeneral,
                                      TNSideImageSmall,
                                      TNSideImageSmall
                                  );
    }
    else
    {
        frameName = CGRectMake(
                                  TNWidthCell - TNMarginName + TNSideImageSmall + TNMarginCategory,
                                  self.usedHeight + TNMarginGeneral,
                                  TNMarginName - TNMarginCategory - TNSideImageSmall,
                                  TNHeightText
                              );
        alignmentName = NSTextAlignmentLeft;
        frameCategory = CGRectMake(
                                      TNWidthCell - TNMarginName,
                                      self.usedHeight + TNMarginGeneral,
                                      TNSideImageSmall,
                                      TNSideImageSmall
                                  );
    }
    
    UILabel *labelName = [UILabel labelSmallBold:NO black:self.blackBackground];
    labelName.frame = frameName;
    labelName.textAlignment = alignmentName;
    labelName.text = score.name;
    [self.scoreNames addObject:labelName];
    [self addSubview:labelName];
    
    UIImageView *imageViewCategory = [[UIImageView alloc] init];
    imageViewCategory.frame = frameCategory;
    [imageViewCategory setImageWithURL:[self.event.tournament.category.image URLByAppendingSize:CGSizeMake(TNSideImageSmall, TNSideImageSmall)]];
    [self.scoreCategories addObject:imageViewCategory];
    [self addSubview:imageViewCategory];
    
    self.usedHeight = CGRectGetMaxY(frameName);
}

- (void)displaySearch:(SearchModel *)search
{
    CGFloat TNHeightSearch = 29.0f;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(
                                                                      0.0f,
                                                                      self.usedHeight,
                                                                      TNWidthCell,
                                                                      TNHeightSearch
                                                                  )];
    self.searchBar.placeholder = NSLocalizedString(@"Quick search...", nil);
    self.searchBar.text = search.query ? : nil;
    self.searchBar.delegate = self;
    [self addSubview:self.searchBar];
    
    self.usedHeight = CGRectGetMaxY(self.searchBar.frame) - TNMarginGeneral;
}

- (void)displayStakeStatus:(NSString *)stakeStatus
                     money:(MoneyModel *)money
               coefficient:(CoefficientModel *)coefficient
                     final:(BOOL)final
{
    NSString *stakeStatusLabel = nil;
    NSString *stakeMoney = nil;
    NSNumberFormatter *twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
    [twoDecimalPlacesFormatter setMaximumFractionDigits:2];
    [twoDecimalPlacesFormatter setMinimumFractionDigits:0];
    CGSize sizeMoney = CGSizeMake(10.0, 10.0f);
    self.imageViewMoney = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                        TNWidthCell - TNMarginGeneral - sizeMoney.width,
                                                                        self.usedHeight + TNMarginGeneral,
                                                                        sizeMoney.width,
                                                                        sizeMoney.height
                                                                        )];
    if ([stakeStatus isEqualToString:@"won"])
    {
        stakeStatusLabel = coefficient ? NSLocalizedString(@"Your stake won!", nil) : NSLocalizedString(@"Your bet won!", nil);
        stakeMoney = [NSString stringWithFormat:@"+%@", [twoDecimalPlacesFormatter stringFromNumber:@(money.amount.integerValue * coefficient.value.doubleValue ? : TNPuntrBetCoefficient)]];
        self.viewStakeStatusBackground = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                  0.0f,
                                                                                  self.usedHeight,
                                                                                  TNWidthCell,
                                                                                  TNHeightText + TNMarginGeneral * 2.0f
                                                                                  )];
        self.viewStakeStatusBackground.backgroundColor = TNColorOrange;
        [self addSubview:self.viewStakeStatusBackground];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavka"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
    }
    else if ([stakeStatus isEqualToString:@"loss"] || [stakeStatus isEqualToString:@"lost"])
    {
        stakeStatusLabel = coefficient ? NSLocalizedString(@"Your stake lost!", nil) : NSLocalizedString(@"Your bet lost!", nil);
        stakeMoney = [NSString stringWithFormat:@"-%@", [twoDecimalPlacesFormatter stringFromNumber:@(money.amount.integerValue)]];
        self.viewStakeStatusBackground = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                  0.0f,
                                                                                  self.usedHeight,
                                                                                  TNWidthCell,
                                                                                  TNHeightText + TNMarginGeneral * 2.0f
                                                                                  )];
        self.viewStakeStatusBackground.backgroundColor = [UIColor colorWithRed:0.80f green:0.20f blue:0.00f alpha:1.00f];
        [self addSubview:self.viewStakeStatusBackground];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavka"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
    }
    else if ([stakeStatus isEqualToString:@"create"] || !stakeStatus)
    {
        stakeStatusLabel = NSLocalizedString(@"Your stake", nil);
        stakeMoney = [NSString stringWithFormat:@"+%@", [twoDecimalPlacesFormatter stringFromNumber:money.amount]];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavkaGrey"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:NO black:self.blackBackground];
    }
    [self addSubview:self.imageViewMoney];
    
    self.labelMoneyAmount = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelMoneyAmount.frame = CGRectMake(
                                             TNMarginGeneral,
                                             self.usedHeight + TNMarginGeneral,
                                             TNWidthCell - TNMarginGeneral * 2.5f - sizeMoney.width,
                                             TNHeightText
                                             );
    self.labelMoneyAmount.text = stakeMoney;
    self.labelMoneyAmount.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelMoneyAmount];
    
    self.labelStakeStatus.frame = CGRectMake(
                                             TNMarginGeneral,
                                             self.usedHeight + TNMarginGeneral,
                                             TNWidthCell - TNMarginGeneral * 2.0f,
                                             TNHeightText
                                             );
    self.labelStakeStatus.text = stakeStatusLabel;
    [self addSubview:self.labelStakeStatus];
    
    self.usedHeight = CGRectGetMaxY(self.labelStakeStatus.frame);
    
    [self makeFinal:final];
}

- (void)displayStartTime:(NSDate *)startTime
                 endTime:(NSDate *)endTime
             stakesCount:(NSNumber *)stakesCount
                   final:(BOOL)final
{
    self.labelEventStartEndTime = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelEventStartEndTime.frame = CGRectMake(
                                                   TNMarginGeneral,
                                                   self.usedHeight + TNMarginGeneral,
                                                   TNWidthCell - TNMarginGeneral * 2.0f,
                                                   TNHeightText
                                                   );
    NSString *timeString = nil;
    NSString * const liveString = NSLocalizedString(@"Live!", nil);
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    timeIntervalFormatter.usesAbbreviatedCalendarUnits = YES;
    // Event will begin later
    if ([startTime isEqualToDate:[startTime laterDate:[NSDate date]]])
    {
        timeString = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:startTime];
    }
    // Event is Live
    else if ([startTime isEqualToDate:[startTime earlierDate:[NSDate date]]] && ([endTime isEqualToDate:[endTime laterDate:[NSDate date]]] || !endTime))
    {
        timeString = liveString;
    }
    // Event is completed
    else if ([endTime isEqualToDate:[endTime earlierDate:[NSDate date]]])
    {
        timeString = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Played", nil), [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:endTime]];
    }
    self.labelEventStartEndTime.text = timeString;
    [self addSubview:self.labelEventStartEndTime];
    
    if ([self.labelEventStartEndTime.text isEqualToString:liveString])
    {
        CGSize sizeLive = CGSizeMake(26.0f, 12.0f);
        CGSize liveSize = [liveString sizeWithFont:TNFontSmall constrainedToSize:self.labelEventStartEndTime.frame.size];
        self.imageViewEventLive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconLive"]];
        self.imageViewEventLive.frame = CGRectMake(
                                                   TNMarginGeneral + liveSize.width + TNMarginGeneral,
                                                   self.usedHeight + TNMarginGeneral - 1,
                                                   sizeLive.width,
                                                   sizeLive.height
                                                   );
        [self addSubview:self.imageViewEventLive];
    }
    
    CGSize sizeSubscribers = CGSizeMake(10.0f, 9.0f);
    CGFloat marginSubscribers = 0.0f;
    self.imageViewEventStakesCount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconUser"]];
    self.imageViewEventStakesCount.frame = CGRectMake(
                                                      TNWidthCell - TNMarginGeneral - sizeSubscribers.width,
                                                      self.usedHeight + TNMarginGeneral + marginSubscribers,
                                                      sizeSubscribers.width,
                                                      sizeSubscribers.height
                                                      );
    [self addSubview:self.imageViewEventStakesCount];
    
    self.labelEventStakesCount = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelEventStakesCount.frame = CGRectMake(
                                                  TNMarginGeneral,
                                                  self.usedHeight + TNMarginGeneral,
                                                  TNWidthCell - TNMarginGeneral * 3.0f - sizeSubscribers.width,
                                                  TNHeightText
                                                  );
    self.labelEventStakesCount.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Stakes count", nil), stakesCount.stringValue];
    self.labelEventStakesCount.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelEventStakesCount];
    
    CGFloat maxY = CGRectGetMaxY(self.labelEventStakesCount.frame);
    [self placeButtonForObject:[self tournamentOrEvent] maxY:maxY + TNMarginGeneral];
    
    self.usedHeight = maxY;
    
    [self makeFinal:final];
}

- (void)displaySubscribedForObject:(id)object
{
    self.buttonSubscribe = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                      TNWidthCell - TNMarginGeneral - TNWidthButtonLarge,
                                                                      self.usedHeight + TNMarginGeneral,
                                                                      TNWidthButtonLarge,
                                                                      TNHeightButton
                                                                     )];
    [self.buttonSubscribe.titleLabel setFont:TNFontSmallBold];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor blackColor];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe.titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.buttonSubscribe];
    if ([object respondsToSelector:@selector(subscribed)])
    {
        [self updateToSubscribed:[object performSelector:@selector(subscribed)]];
    }
}

- (void)displayTopRightTime:(NSDate *)time
{
    self.labelActivityCreatedAt = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelActivityCreatedAt.frame = CGRectMake(
                                                   TNMarginGeneral,
                                                   self.usedHeight + TNMarginGeneral,
                                                   CGRectGetWidth(self.frame) - TNMarginGeneral * 2.0f,
                                                   TNHeightText
                                                   );
    self.labelActivityCreatedAt.textAlignment = NSTextAlignmentRight;
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    timeIntervalFormatter.usesAbbreviatedCalendarUnits = YES;
    self.labelActivityCreatedAt.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:time];
    [self addSubview:self.labelActivityCreatedAt];
}

- (void)displayTournament:(TournamentModel *)tournament arrow:(BOOL)arrow final:(BOOL)final
{
    self.labelTournamentTitle = [UILabel labelSmallBold:YES black:self.blackBackground];
    CGFloat marginTime = self.labelActivityCreatedAt && self.delimiters.count == 0 ? [self.labelActivityCreatedAt sizeThatFits:self.labelActivityCreatedAt.frame.size].width + TNMarginGeneral : 0.0f;
    const CGSize TNSizeTournamentArrow = CGSizeMake(7.0f, 11.0f);
    CGFloat widthLabel = arrow ? TNWidthCell - TNMarginGeneral * 2.0f - marginTime - TNMarginGeneral - TNSizeTournamentArrow.width: TNWidthCell - TNMarginGeneral * 3.0f - TNWidthButtonLarge;
    self.labelTournamentTitle.frame = CGRectMake(
                                                 TNMarginGeneral,
                                                 self.usedHeight + TNMarginGeneral,
                                                 widthLabel,
                                                 TNHeightText
                                                 );
    self.labelTournamentTitle.text = tournament.title;
    [self addSubview:self.labelTournamentTitle];
    
    CGFloat maxY = CGRectGetMaxY(self.labelTournamentTitle.frame);
    
    [self placeButtonForObject:self.tournament maxY:maxY + TNMarginGeneral];
    
    self.usedHeight = maxY;
    
    if (arrow)
    {
        [self displayArrow];
    }
    
    [self makeFinal:final];
}

- (void)displayUser:(UserModel *)user message:(NSString *)message final:(BOOL)final
{
    CGFloat avatarWidth = 0.0f;
    
    // Avatar
    if (user.avatar)
    {
        self.imageViewUserAvatar = [[UIImageView alloc] init];
        self.imageViewUserAvatar.frame = CGRectMake(
                                                    TNMarginGeneral,
                                                    self.usedHeight + TNMarginGeneral,
                                                    TNSideImage,
                                                    TNSideImage
                                                    );
        [self.imageViewUserAvatar imageWithUrl:[user.avatar URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
        [self roundCornersForView:self.imageViewUserAvatar];
        [self addSubview:self.imageViewUserAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewUserAvatar.frame) + TNMarginGeneral;
    }
    
    // Name
    self.labelUserName = [UILabel labelSmallBold:YES black:self.blackBackground];
    CGFloat userNameHeight = message ? TNHeightText : TNSideImage;
    self.labelUserName.frame = CGRectMake(
                                          TNMarginGeneral + avatarWidth,
                                          self.usedHeight + TNMarginGeneral,
                                          TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth,
                                          userNameHeight
                                          );
    self.labelUserName.text = [self nameFromUser:user];
    [self addSubview:self.labelUserName];
    
    CGFloat minY = self.usedHeight;
    
    self.usedHeight = fmax(CGRectGetMaxY(self.labelUserName.frame), CGRectGetMaxY(self.imageViewUserAvatar.frame));
    
    // Message
    if (message)
    {
        self.labelCommentMessage = [UILabel labelSmallBold:NO black:self.blackBackground];
        self.labelCommentMessage.frame = CGRectMake(
                                                    TNMarginGeneral + avatarWidth,
                                                    CGRectGetMaxY(self.labelUserName.frame) + TNMarginGeneral,
                                                    TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth,
                                                    TNHeightText
                                                    );
        self.labelCommentMessage.numberOfLines = 0;
        self.labelCommentMessage.text = message;
        [self.labelCommentMessage sizeToFit];
        [self addSubview:self.labelCommentMessage];
        
        self.usedHeight = fmax(CGRectGetMaxY(self.labelUserName.frame), CGRectGetMaxY(self.labelCommentMessage.frame));
    }
    
    [self placeButtonForObject:self.user frame:CGRectMake(0.0f, minY, TNWidthCell, self.usedHeight + TNMarginGeneral - minY)];
    
    [self makeFinal:final];
}

- (void)placeButtonForObject:(id)object frame:(CGRect)frame
{
    LeadButton *button = [LeadButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.model = object;
    [button addTarget:self action:@selector(buttonLeadTouched:) forControlEvents:UIControlEventTouchUpInside];
    if (self.buttonEventStake)
    {
        [self insertSubview:button belowSubview:self.buttonEventStake];
    }
    else if (self.buttonSubscribe)
    {
        [self insertSubview:button belowSubview:self.buttonSubscribe];
    }
    else
    {
        [self addSubview:button];
        [self bringSubviewToFront:button];
    }
    [self.leadButtons addObject:button];
}

- (void)placeButtonForObject:(id)object maxY:(CGFloat)maxY
{
    CGRect frame = CGRectBetween(self.usedHeight, maxY);
    [self placeButtonForObject:object frame:frame];
}

#pragma mark - Finilize

- (void)makeFinal:(BOOL)final
{
    if (final)
    {
        [self roundCornersForView:self];
    }
    else
    {
        CGFloat delimiterHeight = 1.0f;
        UIImage *delimiterImage = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        
        if (self.blackBackground)
        {
            delimiterHeight = 2.0f;
            delimiterImage = [[UIImage imageNamed:@"delimiterBlack"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        }
        
        UIImageView *delimiter = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                               0.0f,
                                                                               self.usedHeight + TNMarginGeneral,
                                                                               TNWidthCell,
                                                                               delimiterHeight
                                                                              )];
        delimiter.image = delimiterImage;
        [self addSubview:delimiter];
        
        [self.delimiters addObject:delimiter];
        
        self.usedHeight += TNMarginGeneral + delimiterHeight;
    }
}

#pragma mark - Actions

- (void)buttonBetTouched:(LeadButton *)button
{
    [[ObjectManager sharedManager] acceptBet:self.bet
        success:^
        {
            [self reloadData];
        }
        failure:nil
    ];
}

- (void)buttonLeadTouched:(LeadButton *)button
{
    LeadManager *manager = [LeadManager manager];
    [manager actionOnModel:button.model];
}

- (void)subscribe
{
    [[ObjectManager sharedManager] subscribeFor:self.submodel
                                        success:^
        {
            [self updateToSubscribed:@YES];
            [self.submodel performSelector:@selector(setSubscribed:) withObject:@YES];
            [NotificationManager showSuccessMessage:NSLocalizedString(@"You have successfully subscribed!", nil)];
            [self reloadData];
        }
        failure:nil
    ];
}

- (void)segmentValueChanged:(UISegmentedControl *)segmentedControl
{
    SwitchModel *switchModel = (SwitchModel *)self.model;
    CollectionType switchedType;
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        switchedType = switchModel.firstType;
    }
    else
    {
        switchedType = switchModel.secondType;
    }
    [self.delegate switchToType:switchedType];
}

- (void)touchedSwitchDynamicSelection
{
    if([self.model isKindOfClass:[PrivacySettingsModel class]])
    {
        PrivacySettingsModel *privacyModel = (PrivacySettingsModel *)self.model;
        privacyModel.status = [NSNumber numberWithBool:self.switchDynamicSelection.on];
        [[ObjectManager sharedManager] setPrivacy:privacyModel
                                          success:^(NSArray *privacy)
                                          {
                                              [NotificationManager showSuccessMessage:NSLocalizedString(@"You have successfully changed the settings!", nil)];
                                              [self reloadData];
                                          }
                                          failure:nil
        ];

    }
    else if ([self.model isKindOfClass:[PushSettingsModel class]])
    {
        PushSettingsModel *pushModel = (PushSettingsModel *)self.model;
        pushModel.status = [NSNumber numberWithBool:self.switchDynamicSelection.on];
        [[ObjectManager sharedManager] setPush:pushModel
                                       success:^(NSArray *push)
                                       {
                                           [NotificationManager showSuccessMessage:NSLocalizedString(@"You have successfully changed the settings!", nil)];
                                           [self reloadData];
                                       }
                                       failure:^
                                       {
                                           [self reloadData];
                                       }
        ];
    }
    else if ([self.model isKindOfClass:[DynamicSelectionModel class]])
    {
        DynamicSelectionModel *socialModel = (DynamicSelectionModel *)self.model;
        if (self.switchDynamicSelection.on)
        {
            SocialNetworkType socialNetworkType;
            if([socialModel.slug isEqualToString: KeyFacebook])
            {
                socialNetworkType = SocialNetworkTypeFacebook;
            }
            else if ([socialModel.slug isEqualToString: KeyTwitter])
            {
                socialNetworkType = SocialNetworkTypeTwitter;
            }
            else if ([socialModel.slug isEqualToString: KeyVKontakte])
            {
                socialNetworkType = SocialNetworkTypeVkontakte;
            }
            else
            {
                socialNetworkType = SocialNetworkTypeNone;
            }
            
            [[SocialManager sharedManager]loginWithSocialNetworkOfType:socialNetworkType
                                                               success:^(AccessModel *accessModel)
                                                               {
                                                                   [[ObjectManager sharedManager] setSocialsWithAccess:accessModel
                                                                                                               success:^
                                                                                                               {
                                                                                                                   [NotificationManager showSuccessMessage:NSLocalizedString(@"You have successfully changed the settings!", nil)];
                                                                                                                   [self reloadData];
                                                                                                               }
                                                                                                               failure:^
                                                                                                               {
                                                                                                                   [self reloadData];
                                                                                                               }
                                                                   ];
                                                               }
                                                               failure:^(NSError *error)
                                                               {
                                                                   [NotificationManager showError:error];
                                                                   [self reloadData];
                                                               }
             
            ];
        }
        else
        {
            [[ObjectManager sharedManager] disconnectSocialsWithName:socialModel.slug
                                                             success:^
                                                             {
                                                                 [NotificationManager showSuccessMessage:NSLocalizedString(@"You have successfully changed the settings!", nil)];
                                                                 [self reloadData];
                                                             }
                                                             failure:^
                                                             {
                                                                 [self reloadData];
                                                             }
            ];
        }

    }
}

- (void)unsubscribe
{
    [[ObjectManager sharedManager] unsubscribeFrom:(id <Parametrization>)self.submodel
                                           success:^
                                           {
                                               [self updateToSubscribed:@NO];
                                               [self.submodel performSelector:@selector(setSubscribed:) withObject:@NO];
                                               [NotificationManager showSuccessMessage:NSLocalizedString(@"You have successfully unsubscribed!", nil)];
                                               [self reloadData];
                                           }
                                           failure:nil
    ];
}

- (void)updateToSubscribed:(NSNumber *)subscribed
{
    SEL subscribeMethod = subscribed.boolValue ? @selector(unsubscribe) : @selector(subscribe);
    SEL previuosMethod = subscribed.boolValue ? @selector(subscribe) : @selector(unsubscribe);
    NSString *subscribeTitle = subscribed.boolValue ? NSLocalizedString(@"Unsubscribe", nil) : NSLocalizedString(@"Subscribe", nil);
    NSString *subscribeImage = subscribed.boolValue ? @"ButtonRed" : @"ButtonBar";
    CGFloat subscribeImageInset = subscribed.boolValue ? 5.0f : 7.0f;
    
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:subscribeImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, subscribeImageInset, 0.0f, subscribeImageInset)] forState:UIControlStateNormal];
    [self.buttonSubscribe setTitle:subscribeTitle forState:UIControlStateNormal];
    if ([ObjectManager sharedManager].authorized)
    {
        [self.buttonSubscribe removeTarget:self action:previuosMethod forControlEvents:UIControlEventTouchUpInside];
        [self.buttonSubscribe addTarget:self action:subscribeMethod forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.buttonSubscribe removeTarget:self action:previuosMethod forControlEvents:UIControlEventTouchUpInside];
        [self.buttonSubscribe addTarget:[NotificationManager class] action:@selector(unauthorized) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - SearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    if ([self.searchDelegate respondsToSelector:@selector(cancelSearch)])
    {
        [self.searchDelegate cancelSearch];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.searchDelegate respondsToSelector:@selector(searchFor:)])
    {
        [self.searchDelegate searchFor:searchBar.text];
    }
}

- (void)sendDelegateHideKeyboard
{
    if ([self.searchDelegate respondsToSelector:@selector(hideKeyboard)])
    {
        [self.searchDelegate hideKeyboard];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

#pragma mark - Utility

CGRect CGRectBetween(CGFloat minY, CGFloat maxY)
{
    return CGRectMake(0.0f, minY, TNWidthCell, maxY - minY);
}

- (void)cleanArray:(NSMutableArray *)array
{
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    [array removeAllObjects];
}

- (NSString *)nameFromUser:(UserModel *)user
{
    return [NSString stringWithFormat:@"%@ %@", user.firstName ? : user.username, user.lastName ? : @""];
}

- (void)reloadData
{
    if ([self.delegate respondsToSelector:@selector(reloadData)])
    {
        [self.delegate performSelector:@selector(reloadData)];
    }
}

- (void)roundCornersForView:(UIView *)view
{
    view.layer.cornerRadius = TNCornerRadius;
    view.layer.masksToBounds = YES;
}

- (id)tournamentOrEvent
{
    id object = nil;
    if ([self.model isMemberOfClass:[EventModel class]] || ([self.model respondsToSelector:@selector(event)] && [self.model event]))
    {
        object = self.event;
    }
    else if ([self.model isMemberOfClass:[TournamentModel class]] || ([self.model respondsToSelector:@selector(tournament)] && [self.model tournament]))
    {
        object = self.tournament;
    }
    return object;
}

@end
