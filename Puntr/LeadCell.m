//
//  LeadCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ActivityModel.h"
#import "EventModel.h"
#import "LeadCell.h"
#import "NewsModel.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "SmallStakeButton.h"
#import "StakeModel.h"
#import "SubscriptionModel.h"
#import <QuartzCore/QuartzCore.h>
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

static const CGFloat TNMarginGeneral = 8.0f;
static const CGFloat TNHeightText = 12.0f;
static const CGFloat TNWidthCell = 306.0f;
static const CGFloat TNSideImage = 28.0f;
static const CGFloat TNSideImageSmall = 12.0f;
static const CGFloat TNSideImageLarge = 60.0f;
static const CGFloat TNWidthButtonLarge = 94.0f;
static const CGFloat TNWidthButtonSmall = 62.0f;
static const CGFloat TNHeightButton = 31.0f;

#define TNColorText

#define TNFontSmall [UIFont fontWithName:@"ArialMT" size:10.4f]
#define TNFontSmallBold [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]

@interface UILabel (Convenience)

+ (UILabel *)labelSmallBold:(BOOL)bold black:(BOOL)black;

@end

@interface LeadCell ()

@property (nonatomic) CGFloat usedHeight;
@property (nonatomic) BOOL blackBackground;
@property (nonatomic, strong) NSObject *model;
@property (nonatomic, strong) NSObject *modelActive;

// User
@property (nonatomic, strong) UIImageView *imageViewAvatar;
@property (nonatomic, strong) UILabel *labelUserName;
@property (nonatomic, strong) UILabel *labelUserMessage;

// Event
@property (nonatomic, strong) UIImageView *imageViewCategoryImage;
@property (nonatomic, strong) UILabel *labelCategoryTitle;
@property (nonatomic, strong) UILabel *labelTimePublication;
@property (nonatomic, strong) UILabel *labelTimeEvent;
@property (nonatomic, strong) UIImageView *imageViewLive;
@property (nonatomic, strong) UIImageView *imageViewStakers;
@property (nonatomic, strong) UILabel *labelStakesCount;
@property (nonatomic, strong) SmallStakeButton *buttonEventStake;
@property (nonatomic, strong) UILabel *labelParticipants;

// Participant
@property (nonatomic, strong) NSMutableArray *participantLogos;
@property (nonatomic, strong) NSMutableArray *participantTitles;

// Stake
@property (nonatomic, strong) UILabel *labelLine;
@property (nonatomic, strong) UILabel *labelComponents;
@property (nonatomic, strong) UILabel *labelCoefficient;
@property (nonatomic, strong) UILabel *labelCoefficientTitle;
@property (nonatomic, strong) UIView *viewStatusBackground;
@property (nonatomic, strong) UILabel *labelStakeStatus;
@property (nonatomic, strong) UILabel *labelStakeMoney;
@property (nonatomic, strong) UIImageView *imageViewMoney;

// Tournament
@property (nonatomic, strong) UILabel *labelTournament;
@property (nonatomic, strong) UIImageView *imageViewTournamentArrow;
@property (nonatomic, strong) UIButton *buttonTournament;

// Miscelanouos
@property (nonatomic, strong) UIButton *buttonSubscribe;
@property (nonatomic, strong) NSMutableArray *delimiters;

@end

@implementation LeadCell

#pragma mark - Height Calculation

+ (CGSize)sizeForModel:(NSObject *)model
{
    LeadCell *cell = [[self alloc] init];
    [cell loadWithModel:model];
    return CGSizeMake(TNWidthCell, cell.usedHeight + TNMarginGeneral);
}

#pragma mark - General Loading

- (void)loadWithModel:(NSObject *)model
{
    self.model = model;
    if (!self.delimiters)
    {
        self.delimiters = [NSMutableArray array];
    }
    if (!self.participantLogos)
    {
        self.participantLogos = [NSMutableArray array];
    }
    if (!self.participantTitles)
    {
        self.participantTitles = [NSMutableArray array];
    }
    if ([model isMemberOfClass:[EventModel class]])
    {
        [self whiteCell];
        [self loadWithEvent:(EventModel *)model];
    }
    else if ([model isMemberOfClass:[StakeModel class]])
    {
        StakeModel *stake = (StakeModel *)model;
        [self displayBackgroundForStake:stake];
        [self displayTime:stake.createdAt];
        [self loadWithStake:stake];
    }
    else if ([model isMemberOfClass:[ActivityModel class]])
    {
        [self loadWithActivity:(ActivityModel *)model];
    }
    else if ([model isMemberOfClass:[NewsModel class]])
    {
        [self loadWithNews:(NewsModel *)model];
    }
    else if ([model isMemberOfClass:[SubscriptionModel class]])
    {
        [self loadWithSubscription:(SubscriptionModel *)model];
    }
}

- (void)loadWithActivity:(ActivityModel *)activity
{
    [self blackCell];
    [self displayTime:activity.createdAt];
    if (activity.stake)
    {
        [self loadWithStake:activity.stake];
    }
    else if (activity.feed)
    {
        [self loadWithFeed:activity.feed];
    }
}

- (void)loadWithComment:(CommentModel *)comment
{
    [self displayUser:comment.user message:comment.message final:YES];
}

- (void)loadWithEvent:(EventModel *)event
{
    [self displayTournament:event.tournament actionable:NO final:NO];
    [self displayCategory:event.tournament.category];
    [self displayParticipants:event.participants actionable:NO final:NO];
    [self displayEventStartTime:event.startTime endTime:event.endTime stakesCount:event.stakesCount final:YES];
}

- (void)loadWithFeed:(FeedModel *)feed
{
    [self displayUser:feed.user message:feed.message final:YES];
}

- (void)loadWithNews:(NewsModel *)news
{
    [self blackCell];
    [self displayTime:news.createdAt];
    if (news.stake)
    {
        [news.stake setType:news.type];
        [self loadWithStake:news.stake];
    }
    else if (news.feed)
    {
        [self loadWithFeed:news.feed];
    }
    else if (news.comment)
    {
        [self loadWithComment:news.comment];
    }
    else if (news.event)
    {
        [self loadWithEvent:news.event];
    }
}

- (void)loadWithStake:(StakeModel *)stake
{
    BOOL loginedUser = [stake.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]];
    if (!loginedUser)
    {
        [self displayUser:stake.user message:nil final:NO];
    }
    [self displayTournament:stake.event.tournament actionable:NO final:NO];
    [self displayCategory:stake.event.tournament.category];
    [self displayParticipants:stake.event.participants actionable:NO final:NO];
    if (loginedUser)
    {
        
        [self displayStakeStatus:stake.status
                           money:stake.money
                     coefficient:stake.coefficient
                           final:YES];
    }
    else
    {
        [self displayLine:stake.line
               components:stake.components
              coefficient:stake.coefficient
                    final:YES];
    }

}

- (void)loadWithSubscription:(SubscriptionModel *)subscription
{
    [self blackCell];
    if (subscription.participant)
    {
        self.modelActive = subscription.participant;
        [self displaySubscribedForObject:subscription.participant];
        [self displayParticipant:subscription.participant final:YES];
    }
}

#pragma mark - Reloading

- (void)prepareForReuse
{
    self.usedHeight = 0.0f;
    self.blackBackground = NO;
    self.model = nil;
    self.modelActive = nil;
    
    // User
    [self.imageViewAvatar removeFromSuperview];
    [self.labelUserName removeFromSuperview];
    [self.labelUserMessage removeFromSuperview];
    
    // Event
    [self.imageViewCategoryImage removeFromSuperview];
    [self.labelCategoryTitle removeFromSuperview];
    [self.labelTimePublication removeFromSuperview];
    [self.labelTimeEvent removeFromSuperview];
    [self.imageViewLive removeFromSuperview];
    [self.imageViewStakers removeFromSuperview];
    [self.labelStakesCount removeFromSuperview];
    [self.buttonEventStake removeFromSuperview];
    [self.labelParticipants removeFromSuperview];
    
    // Participant
    for (UIImageView *logo in self.participantLogos) {
        [logo removeFromSuperview];
    }
    [self.participantLogos removeAllObjects];
    
    for (UILabel *title in self.participantTitles) {
        [title removeFromSuperview];
    }
    [self.participantTitles removeAllObjects];
    
    // Stake
    [self.labelLine removeFromSuperview];
    [self.labelComponents removeFromSuperview];
    [self.labelCoefficient removeFromSuperview];
    [self.labelCoefficientTitle removeFromSuperview];
    [self.viewStatusBackground removeFromSuperview];
    [self.labelStakeStatus removeFromSuperview];
    [self.labelStakeMoney removeFromSuperview];
    [self.imageViewMoney removeFromSuperview];
    
    // Tournament
    [self.labelTournament removeFromSuperview];
    [self.imageViewTournamentArrow removeFromSuperview];
    [self.buttonTournament removeFromSuperview];
    
    // Miscelanouos
    for (UIImageView *imageView in self.delimiters)
    {
        [imageView removeFromSuperview];
    }
    [self.delimiters removeAllObjects];
    [self.buttonSubscribe removeFromSuperview];
}

#pragma mark - Lead Components

- (void)whiteCell
{
    self.backgroundColor = [UIColor whiteColor];
    self.blackBackground = NO;
}

- (void)blackCell
{
    self.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    self.blackBackground = YES;
}

- (void)displayBackgroundForStake:(StakeModel *)stake
{
    if ([stake.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]])
    {
        [self blackCell];
    }
    else
    {
        [self whiteCell];
    }
}

- (void)displayTime:(NSDate *)time
{
    self.labelTimePublication = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelTimePublication.frame = CGRectMake(
                                                    TNMarginGeneral,
                                                    TNMarginGeneral,
                                                    CGRectGetWidth(self.frame) - TNMarginGeneral * 2.0f,
                                                    TNHeightText
                                                );
    self.labelTimePublication.textAlignment = NSTextAlignmentRight;
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    timeIntervalFormatter.usesAbbreviatedCalendarUnits = YES;
    self.labelTimePublication.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:time];
    [self addSubview:self.labelTimePublication];
}

- (void)displayEventStartTime:(NSDate *)startTime
                      endTime:(NSDate *)endTime
                  stakesCount:(NSNumber *)stakesCount
                        final:(BOOL)final
{
    self.labelTimeEvent = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelTimeEvent.frame = CGRectMake(
                                              TNMarginGeneral,
                                              self.usedHeight + TNMarginGeneral,
                                              TNWidthCell - TNMarginGeneral * 2.0f,
                                              TNHeightText
                                          );
    NSString *timeString = nil;
    NSString * const liveString = @"Уже идет!";
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
        timeString = [NSString stringWithFormat:@"Сыграно %@", [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:endTime]];
    }
    self.labelTimeEvent.text = timeString;
    [self addSubview:self.labelTimeEvent];
    
    if ([self.labelTimeEvent.text isEqualToString:liveString])
    {
        CGSize sizeLive = CGSizeMake(26.0f, 12.0f);
        CGSize liveSize = [liveString sizeWithFont:TNFontSmall constrainedToSize:self.labelTimeEvent.frame.size];
        self.imageViewLive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconLive"]];
        self.imageViewLive.frame = CGRectMake(
                                                 TNMarginGeneral + liveSize.width + TNMarginGeneral,
                                                 self.usedHeight + TNMarginGeneral,
                                                 sizeLive.width,
                                                 sizeLive.height
                                             );
        [self addSubview:self.imageViewLive];
    }
    
    CGSize sizeSubscribers = CGSizeMake(10.0f, 9.0f);
    CGFloat marginSubscribers = 0.0f;
    self.imageViewStakers = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconUser"]];
    self.imageViewStakers.frame = CGRectMake(
                                                    TNWidthCell - TNMarginGeneral - sizeSubscribers.width,
                                                    self.usedHeight + TNMarginGeneral + marginSubscribers,
                                                    sizeSubscribers.width,
                                                    sizeSubscribers.height
                                                );
    [self addSubview:self.imageViewStakers];
    
    self.labelStakesCount = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelStakesCount.frame = CGRectMake(
                                                TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                TNWidthCell - TNMarginGeneral * 3.0f - sizeSubscribers.width,
                                                TNHeightText
                                            );
    NSString *stakesCountString = nil;
    if ([stakesCount isEqualToNumber:@0])
    {
        stakesCountString = @"Поставьте первым!";
    }
    else
    {
        stakesCountString = [NSString stringWithFormat:@"Ставок: %@", stakesCount.stringValue];
    }
    self.labelStakesCount.text = stakesCountString;
    self.labelStakesCount.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelStakesCount];
    
    self.usedHeight = CGRectGetMaxY(self.labelStakesCount.frame);
    
    [self makeFinal:final];
}

- (void)displayUser:(UserModel *)user message:(NSString *)message final:(BOOL)final
{
    CGFloat avatarWidth = 0.0f;
    
    // Avatar
    if (user.avatar)
    {
        self.imageViewAvatar = [[UIImageView alloc] init];
        self.imageViewAvatar.frame = CGRectMake(
                                                   TNMarginGeneral,
                                                   self.usedHeight + TNMarginGeneral,
                                                   TNSideImage,
                                                   TNSideImage
                                               );
        [self.imageViewAvatar setImageWithURL:[user.avatar URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
        [self addSubview:self.imageViewAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewAvatar.frame) + TNMarginGeneral;
        self.usedHeight = CGRectGetMaxY(self.imageViewAvatar.frame);
    }
    
    // Name
    self.labelUserName = [UILabel labelSmallBold:YES black:self.blackBackground];
    CGFloat userNameHeight = user.avatar && !message ? TNSideImage : TNHeightText;
    self.labelUserName.frame = CGRectMake(
                                          TNMarginGeneral + avatarWidth,
                                          self.usedHeight + TNMarginGeneral,
                                          TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth,
                                          userNameHeight
                                         );
    self.labelUserName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    [self addSubview:self.labelUserName];
    
    self.usedHeight = fmax(CGRectGetMaxY(self.labelUserName.frame), CGRectGetMaxY(self.imageViewAvatar.frame));
    
    // Message
    if (message)
    {
        self.labelUserMessage = [UILabel labelSmallBold:NO black:self.blackBackground];
        self.labelUserMessage.frame = CGRectMake(
                                                 TNMarginGeneral + avatarWidth,
                                                 CGRectGetMaxY(self.labelUserName.frame) + TNMarginGeneral,
                                                 TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth,
                                                 CGFLOAT_MAX
                                                 );
        self.labelUserMessage.numberOfLines = 0;
        self.labelUserMessage.text = message;
        [self.labelUserMessage sizeToFit];
        [self addSubview:self.labelUserMessage];
        
        self.usedHeight = fmax(CGRectGetMaxY(self.labelUserName.frame), CGRectGetMaxY(self.labelUserMessage.frame));
    }
    
    [self makeFinal:final];
}

- (void)displayCategory:(CategoryModel *)category
{
    CGFloat categoryImageWidth = 0.0f;
    CGSize categoryImageSize = CGSizeMake(12.0f, 12.0f);
    
    if (category.image)
    {
        self.imageViewCategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                       TNMarginGeneral,
                                                                                       self.usedHeight + TNMarginGeneral,
                                                                                       categoryImageSize.width,
                                                                                       categoryImageSize.height
                                                                                   )];
        [self.imageViewCategoryImage setImageWithURL:[category.image URLByAppendingSize:categoryImageSize]];
        [self addSubview:self.imageViewCategoryImage];
        
        categoryImageWidth = CGRectGetMaxX(self.imageViewCategoryImage.frame) + TNMarginGeneral;
    }
    
    self.labelCategoryTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelCategoryTitle.frame = CGRectMake(
                                               TNMarginGeneral + categoryImageWidth,
                                               self.usedHeight + TNMarginGeneral,
                                               TNWidthCell - TNMarginGeneral * 2.0f - categoryImageWidth,
                                               TNHeightText
                                               );
    self.labelCategoryTitle.text = category.title;
    [self addSubview:self.labelCategoryTitle];
    
    self.usedHeight = CGRectGetMaxY(self.labelCategoryTitle.frame);
}

- (void)displayTournament:(TournamentModel *)tournament actionable:(BOOL)actionable final:(BOOL)final
{
    self.labelTournament = [UILabel labelSmallBold:YES black:self.blackBackground];
    CGFloat widthLabel = actionable ? TNWidthCell - TNMarginGeneral * 3.0f - TNWidthButtonLarge : TNWidthCell - TNMarginGeneral * 2.0f;
    self.labelTournament.frame = CGRectMake(
                                                TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                widthLabel,
                                                TNHeightText
                                           );
    self.labelTournament.text = tournament.title;
    [self addSubview:self.labelTournament];
    
    self.usedHeight = CGRectGetMaxY(self.labelTournament.frame);
    
    if (actionable)
    {
        self.buttonTournament = [UIButton buttonWithType:UIButtonTypeCustom];
        const CGFloat TNMarginButtonTournament = 4.0f;
        self.buttonTournament.frame = CGRectMake(
                                                     TNWidthCell - TNMarginGeneral - TNWidthButtonLarge,
                                                     self.usedHeight + TNMarginButtonTournament - TNHeightButton,
                                                     TNWidthButtonLarge,
                                                     TNHeightButton
                                                );
        [self.buttonTournament setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)]
                                         forState:UIControlStateNormal];
        self.buttonTournament.adjustsImageWhenHighlighted = NO;
        [self.buttonTournament setTitle:@"Подписаться" forState:UIControlStateNormal];
        self.buttonTournament.titleLabel.font = TNFontSmallBold;
        self.buttonTournament.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
        self.buttonTournament.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
        [self.buttonTournament addTarget:self action:@selector(touchedButtonTournamentSubscribe:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonTournament];
    }
    else
    {
        self.imageViewTournamentArrow = [[UIImageView alloc] init];
        CGFloat marginTime = self.labelTimePublication && self.delimiters.count == 0 ? [self.labelTimePublication sizeThatFits:self.labelTimePublication.frame.size].width + TNMarginGeneral : 0.0f;
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
    
    [self makeFinal:final];
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
        [imageViewParticipantLogo setImageWithURL:[participant.logo URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
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
    
    self.usedHeight = CGRectGetMaxY(labelParticipantTitle.frame);
    
    [self makeFinal:final];
}

- (void)displayParticipants:(NSArray *)participants actionable:(BOOL)actionable final:(BOOL)final
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
                [imageViewParticipantLogo setImageWithURL:[participant.logo URLByAppendingSize:sizeLogo]];
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
    
    self.usedHeight = CGRectGetMaxY([self.participantTitles.lastObject frame]);
    
    [self makeFinal:final];
}

- (void)displayLine:(LineModel *)line
         components:(NSArray *)components
        coefficient:(CoefficientModel *)coefficient
              final:(BOOL)final
{
    // Line
    self.labelLine = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelLine.frame = CGRectMake(
                                          TNMarginGeneral,
                                          self.usedHeight + TNMarginGeneral,
                                          TNWidthCell - TNMarginGeneral * 2.0f,
                                          TNHeightText
                                     );
    NSString *capitalisedLine = [[line.title lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                      withString:[[line.title  substringToIndex:1] capitalizedString]];
    self.labelLine.text = [NSString stringWithFormat:@"%@:", capitalisedLine];
    [self.labelLine sizeToFit];
    [self addSubview:self.labelLine];
    
    // Components
    self.labelComponents = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelComponents.frame = CGRectMake(
                                                CGRectGetMaxX(self.labelLine.frame) + TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                TNWidthCell - (CGRectGetMaxX(self.labelLine.frame) + TNMarginGeneral * 3.0f),
                                                TNHeightText
                                           );
    NSMutableString *componentsCombined = [[NSMutableString alloc] init];
    for (ComponentModel *component in components)
    {
        [componentsCombined appendFormat:@"%@ ", component.selectedCriterionObject.title];
    }
    self.labelComponents.text = [componentsCombined copy];
    [self.labelComponents sizeToFit];
    [self addSubview:self.labelComponents];
    
    // Coefficient
    NSNumberFormatter *twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
    [twoDecimalPlacesFormatter setMaximumFractionDigits:2];
    [twoDecimalPlacesFormatter setMinimumFractionDigits:0];
    NSString *coefficientString = [NSString stringWithFormat:@"Коэффициент: %@", [twoDecimalPlacesFormatter stringFromNumber:coefficient.value]];
    CGPoint coefficientOrigin = CGPointMake(TNMarginGeneral, CGRectGetMaxY(self.labelLine.frame) + TNMarginGeneral);
    CGSize coefficientSize = [coefficientString sizeWithFont:TNFontSmall constrainedToSize:CGSizeMake(TNWidthCell - TNMarginGeneral * 2.0f, TNHeightText)];
    if (coefficientSize.width <= TNWidthCell - CGRectGetMaxX(self.labelComponents.frame) - TNMarginGeneral * 2.0f)
    {
        coefficientOrigin = CGPointMake(
                                        CGRectGetMaxX(self.labelComponents.frame) + TNMarginGeneral,
                                        self.usedHeight + TNMarginGeneral
                                       );
    }
    self.labelCoefficient = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelCoefficient.frame = CGRectMake(
                                             coefficientOrigin.x,
                                             coefficientOrigin.y,
                                             coefficientSize.width,
                                             coefficientSize.height
                                            );
    self.labelCoefficient.text = coefficientString;
    [self addSubview:self.labelCoefficient];
    
    self.usedHeight = CGRectGetMaxY(self.labelCoefficient.frame);
    
    [self makeFinal:final];
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
        stakeStatusLabel = @"Ваша ставка выиграла!";
        stakeMoney = [NSString stringWithFormat:@"+%@", [twoDecimalPlacesFormatter stringFromNumber:@(money.amount.integerValue * coefficient.value.doubleValue)]];
        self.viewStatusBackground = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                0.0f,
                                                                                self.usedHeight,
                                                                                TNWidthCell,
                                                                                TNHeightText + TNMarginGeneral * 2.0f
                                                                            )];
        self.viewStatusBackground.backgroundColor = [UIColor colorWithRed:0.80f green:0.60f blue:0.20f alpha:1.00f];
        [self addSubview:self.viewStatusBackground];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavka"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
    }
    else if ([stakeStatus isEqualToString:@"loss"] || [stakeStatus isEqualToString:@"lost"])
    {
        stakeStatusLabel = @"Ваша ставка проиграла!";
        stakeMoney = [NSString stringWithFormat:@"-%@", [twoDecimalPlacesFormatter stringFromNumber:@(money.amount.integerValue * coefficient.value.doubleValue)]];
        self.viewStatusBackground = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                0.0f,
                                                                                self.usedHeight,
                                                                                TNWidthCell,
                                                                                TNHeightText + TNMarginGeneral * 2.0f
                                                                            )];
        self.viewStatusBackground.backgroundColor = [UIColor colorWithRed:0.80f green:0.20f blue:0.00f alpha:1.00f];
        [self addSubview:self.viewStatusBackground];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavka"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
    }
    else if ([stakeStatus isEqualToString:@"create"] || !stakeStatus)
    {
        stakeStatusLabel = @"Ваша ставка";
        stakeMoney = [NSString stringWithFormat:@"+%@", [twoDecimalPlacesFormatter stringFromNumber:money.amount]];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavkaGrey"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:NO black:self.blackBackground];
    }
    [self addSubview:self.imageViewMoney];
    
    self.labelStakeMoney = [UILabel labelSmallBold:YES black:self.blackBackground];
    self.labelStakeMoney.frame = CGRectMake(
                                                TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                TNWidthCell - TNMarginGeneral * 2.5f - sizeMoney.width,
                                                TNHeightText
                                           );
    self.labelStakeMoney.text = stakeMoney;
    self.labelStakeMoney.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelStakeMoney];
    
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

- (void)displaySubscribedForObject:(NSObject *)object
{
    self.buttonSubscribe = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                      TNWidthCell - TNMarginGeneral - TNWidthButtonLarge,
                                                                      self.usedHeight + TNMarginGeneral,
                                                                      TNWidthButtonLarge,
                                                                      TNHeightButton
                                                                     )];
    [self.buttonSubscribe.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12.0f]];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor blackColor];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe.titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.buttonSubscribe];
    if ([object respondsToSelector:@selector(subscribed)])
    {
        [self updateToSubscribed:[object performSelector:@selector(subscribed)]];
    }
}

#pragma mark - Finilize

- (void)makeFinal:(BOOL)final
{
    if (final)
    {
        self.layer.cornerRadius = 3.75f;
        self.layer.masksToBounds = YES;
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

- (void)touchedButtonTournamentSubscribe:(UIButton *)button
{
    NSLog(@"Tournament Subscribe button touched");
}

- (void)subscribe
{
    [[ObjectManager sharedManager] subscribeFor:self.modelActive
                                        success:^
                                        {
                                            [self updateToSubscribed:@YES];
                                            [self.modelActive performSelector:@selector(setSubscribed:) withObject:@YES];
                                            [NotificationManager showSuccessMessage:@"Вы успешно подписались!"];
                                        }
                                        failure:nil
    ];
}

- (void)unsubscribe
{
    [[ObjectManager sharedManager] unsubscribeFrom:(id <Parametrization>)self.modelActive
                                           success:^
                                           {
                                               [self updateToSubscribed:@NO];
                                               [self.modelActive performSelector:@selector(setSubscribed:) withObject:@NO];
                                               [NotificationManager showSuccessMessage:@"Вы успешно отписались!"];
                                           }
                                           failure:nil
    ];
}

- (void)updateToSubscribed:(NSNumber *)subscribed
{
    SEL subscribeMethod = subscribed.boolValue ? @selector(unsubscribe) : @selector(subscribe);
    SEL previuosMethod = subscribed.boolValue ? @selector(subscribe) : @selector(unsubscribe);
    NSString *subscribeTitle = subscribed.boolValue ? @"Отписаться" : @"Подписаться";
    NSString *subscribeImage = subscribed.boolValue ? @"ButtonRed" : @"ButtonBar";
    CGFloat subscribeImageInset = subscribed.boolValue ? 5.0f : 7.0f;
    
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:subscribeImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, subscribeImageInset, 0.0f, subscribeImageInset)] forState:UIControlStateNormal];
    [self.buttonSubscribe setTitle:subscribeTitle forState:UIControlStateNormal];
    [self.buttonSubscribe removeTarget:self action:previuosMethod forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSubscribe addTarget:self action:subscribeMethod forControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation UILabel (Convenience)

+ (UILabel *)labelSmallBold:(BOOL)bold black:(BOOL)black
{
    UILabel *label = [[UILabel alloc] init];
    label.font = bold ? TNFontSmallBold : TNFontSmall;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = black ? [UIColor whiteColor] : [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    return label;
}

@end
