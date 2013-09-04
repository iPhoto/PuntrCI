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
#import "StakeViewController.h"
#import "UILabel+Puntr.h"
#import <QuartzCore/QuartzCore.h>
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

static const CGFloat TNHeightButton = 31.0f;
static const CGFloat TNHeightSwitch = 27.0f;
static const CGFloat TNHeightText = 12.0f;
static const CGFloat TNMarginGeneral = 8.0f;
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
@property (nonatomic, retain) UILabel *labelAwardDescription;
@property (nonatomic, retain) UIButton *buttonAwardShare;

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
@property (nonatomic, strong) UIButton *buttonEventStake;

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
@property (nonatomic, strong) NSMutableArray *participantLogos;
@property (nonatomic, strong) NSMutableArray *participantTitles;

// Privacy and Push
@property (nonatomic, strong) UILabel *labelDynamicSelectionTitle;
@property (nonatomic, strong) UILabel *labelDynamicSelectionDescription;
@property (nonatomic, strong) UISwitch *switchDynamicSelection;

// Stake
@property (nonatomic, strong) UIView *viewStakeStatusBackground;
@property (nonatomic, strong) UILabel *labelStakeStatus;

// Subscription
@property (nonatomic, strong) UIButton *buttonSubscribe;

// Tournament
@property (nonatomic, strong) UILabel *labelTournamentTitle;
@property (nonatomic, strong) UIImageView *imageViewTournamentArrow;
@property (nonatomic, strong) UIButton *buttonTournament;

// User
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) UILabel *labelUserName;
@property (nonatomic, strong) UIImageView *imageViewUserAvatar;

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
    TNRemove(self.labelAwardDescription)
    TNRemove(self.buttonAwardShare)
    
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
    [self cleanArray:self.participantLogos];
    [self cleanArray:self.participantTitles];
    
    // Privacy and Push
    TNRemove(self.labelDynamicSelectionTitle)
    TNRemove(self.labelDynamicSelectionDescription)
    TNRemove(self.switchDynamicSelection)
    
    // Stake
    TNRemove(self.viewStakeStatusBackground)
    TNRemove(self.labelStakeStatus)
    
    // Subscription
    TNRemove(self.buttonSubscribe)
    
    // Tournament
    TNRemove(self.labelTournamentTitle)
    TNRemove(self.imageViewTournamentArrow)
    
    // User
    self.user = nil;
    TNRemove(self.labelUserName)
    TNRemove(self.imageViewUserAvatar)
    
    // Miscelanouos
    TNRemove(self.imageViewBanner)
    [self cleanArray:self.delimiters];
    
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
    else if ([model isMemberOfClass:[EventModel class]])
    {
        [self whiteCell];
        [self loadWithEvent:(EventModel *)model];
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
    else if ([model isMemberOfClass:[PushSettingsModel class]] || [model isMemberOfClass:[PrivacySettingsModel class]])
    {
        [self loadWithDynamicSelection:(DynamicSelectionModel *)model];
    }
    else if ([model isMemberOfClass:[StakeModel class]])
    {
        StakeModel *stake = (StakeModel *)model;
        [self displayBackgroundForStake:stake];
        [self displayTopRightTime:stake.createdAt];
        [self loadWithStake:stake];
    }
    else if ([model isMemberOfClass:[SubscriptionModel class]])
    {
        [self loadWithSubscription:(SubscriptionModel *)model];
    }
    else if ([model isMemberOfClass:[TournamentModel class]])
    {
        [self loadWithTournament:(TournamentModel *)model];
    }
    else if ([model isMemberOfClass:[DynamicSelectionModel class]])
    {
        [self loadWithDynamicSelection:(DynamicSelectionModel *)model];
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
}

- (void)loadWithAward:(AwardModel *)award
{
    [self blackCell];
    self.usedHeight = TNSideBadge;
    self.usedWidth = TNSideBadge;
    [self displayAward:award];
}

- (void)loadWithComment:(CommentModel *)comment
{
    self.event = comment.event;
    self.user = comment.user;
    [self displayUser:comment.user message:comment.message final:YES];
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
    if (event.banner) {
        [self displayBanner:event.banner];
    }
    [self displayTournament:event.tournament arrow:YES final:NO];
    if (![event.endTime isEqualToDate:[event.endTime earlierDate:[NSDate date]]])
    {
        [self displayStakeButton];
    }
    [self displayCategory:event.tournament.category];
    [self displayParticipants:event.participants final:NO];
    [self displayStartTime:event.startTime endTime:event.endTime stakesCount:event.stakesCount final:YES];
}

- (void)loadWithNews:(NewsModel *)news
{
    [self blackCell];
    [self displayTopRightTime:news.createdAt];
    if (news.stake)
    {
        [news.stake setType:news.type];
        [self loadWithStake:news.stake];
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
        self.user = stake.user;
        [self displayUser:stake.user message:nil final:NO];
    }
    self.event = stake.event;
    [self displayTournament:stake.event.tournament arrow:YES final:NO];
    [self displayCategory:stake.event.tournament.category];
    [self displayParticipants:stake.event.participants final:NO];
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
        self.submodel = subscription.participant;
        [self displaySubscribedForObject:self.submodel];
        [self displayParticipant:subscription.participant final:YES];
    }
    else if (subscription.event)
    {
        self.event = subscription.event;
        self.submodel = subscription.event;
        [self displaySubscribedForObject:self.submodel];
        [self displayCategory:subscription.event.tournament.category];
        [self displayParticipants:subscription.event.participants final:NO];
        [self displayStartTime:subscription.event.startTime endTime:subscription.event.endTime stakesCount:subscription.event.stakesCount final:YES];
    }
}

- (void)loadWithTournament:(TournamentModel *)tournament
{
    [self whiteCell];
    if (tournament.banner) {
        [self displayBanner:tournament.banner];
    }
    [self displayCategory:tournament.category];
    [self displayTournament:tournament arrow:NO final:NO];
    [self displayStartTime:tournament.startTime endTime:tournament.endTime stakesCount:tournament.stakesCount final:YES];
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
    CGSize awardImageSize = CGSizeMake(TNSideBadge, TNSideBadge);

    self.imageViewAward = [[UIImageView alloc] initWithFrame:CGRectMake(8.0f, 8.0f, (self.frame.size.height / 2) - 16.0f, (self.frame.size.width / 2) - 16.0f)];
//    [self.imageViewAward setImageWithURL:[award.image URLByAppendingSize:awardImageSize]];
    [self.imageViewAward setImageWithURL:award.image];
    self.imageViewAward.backgroundColor = [UIColor blueColor];

    self.labelAwardTitle = [UILabel labelSmallBold:YES black:YES];
    self.labelAwardDescription = [UILabel labelSmallBold:YES black:YES];
    [self addSubview:self.imageViewAward];
    [self addSubview:self.labelAwardTitle];
    [self addSubview:self.labelAwardDescription];
    self.labelAwardTitle.text = award.title;
    [self.labelAwardTitle sizeToFit];
    self.labelAwardTitle.backgroundColor = [UIColor greenColor];

    self.labelAwardDescription.text = award.description;
    [self.labelAwardDescription sizeToFit];
    self.labelAwardDescription.backgroundColor = [UIColor greenColor];
    
    self.labelAwardTitle.center = CGPointMake(CGRectGetMaxX(self.imageViewAward.frame) + (self.labelAwardTitle.frame.size.width / 2) + 8.0f, CGRectGetMidY(self.imageViewAward.frame));
    self.labelAwardDescription.center = CGPointMake(CGRectGetMinX(self.imageViewAward.frame) + (self.labelAwardDescription.frame.size.width / 2), CGRectGetMaxY(self.imageViewAward.frame) + (self.labelAwardDescription.frame.size.height / 2) + 8.0f);
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
    [self.imageViewBanner setImageWithURL:[banner URLByAppendingSize:sizeBanner]];
    [self addSubview:self.imageViewBanner];
    
    [self placeButtonForObject:self.event frame:self.imageViewBanner.frame];
    
    self.usedHeight = CGRectGetMaxY(self.imageViewBanner.frame);
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
        
        categoryImageWidth = CGRectGetMaxX(self.imageViewCategoryImage.frame);
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
    
    CGFloat maxY = CGRectGetMaxY(self.labelCategoryTitle.frame);
    [self placeButtonForObject:self.event maxY:maxY];
    
    self.usedHeight = maxY;
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
            [self.imageViewGroupImage setImageWithURL:group.image];
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
    // Line
    self.labelLineTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    self.labelLineTitle.frame = CGRectMake(
                                          TNMarginGeneral,
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
    NSNumberFormatter *twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
    [twoDecimalPlacesFormatter setMaximumFractionDigits:2];
    [twoDecimalPlacesFormatter setMinimumFractionDigits:0];
    NSString *coefficientString = [NSString stringWithFormat:@"Коэффициент: %@", [twoDecimalPlacesFormatter stringFromNumber:coefficient.value]];
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
    
    CGFloat maxY = CGRectGetMaxY([self.participantTitles.lastObject frame]);
    [self placeButtonForObject:self.event maxY:maxY + TNMarginGeneral];
    
    self.usedHeight = maxY;
    
    [self makeFinal:final];
}

- (void)displayStakeButton
{
    self.buttonEventStake = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [self.buttonEventStake setTitle:@"Ставить" forState:UIControlStateNormal];
    [self.buttonEventStake addTarget:self action:@selector(openStake) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonEventStake];
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
        self.viewStakeStatusBackground = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                  0.0f,
                                                                                  self.usedHeight,
                                                                                  TNWidthCell,
                                                                                  TNHeightText + TNMarginGeneral * 2.0f
                                                                                  )];
        self.viewStakeStatusBackground.backgroundColor = [UIColor colorWithRed:0.80f green:0.60f blue:0.20f alpha:1.00f];
        [self addSubview:self.viewStakeStatusBackground];
        
        self.imageViewMoney.image = [UIImage imageNamed:@"IconMoneyStavka"];
        
        self.labelStakeStatus = [UILabel labelSmallBold:YES black:self.blackBackground];
    }
    else if ([stakeStatus isEqualToString:@"loss"] || [stakeStatus isEqualToString:@"lost"])
    {
        stakeStatusLabel = @"Ваша ставка проиграла!";
        stakeMoney = [NSString stringWithFormat:@"-%@", [twoDecimalPlacesFormatter stringFromNumber:@(money.amount.integerValue * coefficient.value.doubleValue)]];
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
        stakeStatusLabel = @"Ваша ставка";
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
    self.labelEventStartEndTime.text = timeString;
    [self addSubview:self.labelEventStartEndTime];
    
    if ([self.labelEventStartEndTime.text isEqualToString:liveString])
    {
        CGSize sizeLive = CGSizeMake(26.0f, 12.0f);
        CGSize liveSize = [liveString sizeWithFont:TNFontSmall constrainedToSize:self.labelEventStartEndTime.frame.size];
        self.imageViewEventLive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconLive"]];
        self.imageViewEventLive.frame = CGRectMake(
                                                   TNMarginGeneral + liveSize.width + TNMarginGeneral,
                                                   self.usedHeight + TNMarginGeneral,
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
    NSString *stakesCountString = nil;
    if ([stakesCount isEqualToNumber:@0])
    {
        stakesCountString = @"Поставьте первым!";
    }
    else
    {
        stakesCountString = [NSString stringWithFormat:@"Ставок: %@", stakesCount.stringValue];
    }
    self.labelEventStakesCount.text = stakesCountString;
    self.labelEventStakesCount.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelEventStakesCount];
    
    CGFloat maxY = CGRectGetMaxY(self.labelEventStakesCount.frame);
    [self placeButtonForObject:self.event maxY:maxY + TNMarginGeneral];
    
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
                                                   TNMarginGeneral,
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
    CGFloat widthLabel = arrow ? TNWidthCell - TNMarginGeneral * 2.0f : TNWidthCell - TNMarginGeneral * 3.0f - TNWidthButtonLarge;
    self.labelTournamentTitle.frame = CGRectMake(
                                                 TNMarginGeneral,
                                                 self.usedHeight + TNMarginGeneral,
                                                 widthLabel,
                                                 TNHeightText
                                                 );
    self.labelTournamentTitle.text = tournament.title;
    [self addSubview:self.labelTournamentTitle];
    
    self.usedHeight = CGRectGetMaxY(self.labelTournamentTitle.frame);
    
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
        [self.imageViewUserAvatar setImageWithURL:[user.avatar URLByAppendingSize:CGSizeMake(TNSideImage, TNSideImage)]];
        [self addSubview:self.imageViewUserAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewUserAvatar.frame) + TNMarginGeneral;
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
    }
    [self.leadButtons addObject:button];
}

- (void)placeButtonForObject:(id)object maxY:(CGFloat)maxY
{
    CGRect frame = CGRectBetween(self.usedHeight, maxY);
    [self placeButtonForObject:self.event frame:frame];
}

- (void)whiteCell
{
    self.backgroundColor = [UIColor whiteColor];
    self.blackBackground = NO;
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

- (void)buttonLeadTouched:(LeadButton *)button
{
    LeadManager *manager = [LeadManager manager];
    [manager actionOnModel:button.model];
}

- (void)openStake
{
    StakeViewController *stakeViewController = [[StakeViewController alloc] initWithEvent:(EventModel *)self.submodel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:stakeViewController];
    [[PuntrUtilities mainNavigationController] presentViewController:navigationController animated:YES completion:nil];
}

- (void)subscribe
{
    [[ObjectManager sharedManager] subscribeFor:self.submodel
                                        success:^
     {
         [self updateToSubscribed:@YES];
         [self.submodel performSelector:@selector(setSubscribed:) withObject:@YES];
         [NotificationManager showSuccessMessage:@"Вы успешно подписались!"];
     }
                                        failure:nil
     ];
}

- (void)touchedSwitchDynamicSelection
{
    if([self.model isKindOfClass:[PrivacySettingsModel class]])
    {
        PrivacySettingsModel *privacyModel = (PrivacySettingsModel *)self.submodel;
        privacyModel.status = [NSNumber numberWithBool:self.switchDynamicSelection.on];
        [[ObjectManager sharedManager] setPrivacy:privacyModel
                                          success:^(NSArray *privacy)
                                          {
                                              [NotificationManager showSuccessMessage:@"Вы успешно изменили настройки!"];
                                              [self.delegate reloadData];
                                          }
                                          failure:nil
        ];

    }
    else if ([self.model isKindOfClass:[PushSettingsModel class]])
    {
        PushSettingsModel *pushModel = (PushSettingsModel *)self.submodel;
        pushModel.status = [NSNumber numberWithBool:self.switchDynamicSelection.on];
        [[ObjectManager sharedManager] setPush:pushModel
                                       success:^(NSArray *push)
                                       {
                                           [NotificationManager showSuccessMessage:@"Вы успешно изменили настройки!"];
                                           [self.delegate reloadData];
                                       }
                                       failure:nil
        ];
    }
}

- (void)unsubscribe
{
    [[ObjectManager sharedManager] unsubscribeFrom:(id <Parametrization>)self.submodel
                                           success:^
                                           {
                                               [self updateToSubscribed:@NO];
                                               [self.submodel performSelector:@selector(setSubscribed:) withObject:@NO];
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

@end