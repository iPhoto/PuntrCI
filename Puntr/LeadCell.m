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
#import "ObjectManager.h"
#import "SmallStakeButton.h"
#import "StakeModel.h"
#import <QuartzCore/QuartzCore.h>
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

static const CGFloat TNMarginGeneral = 8.0f;
static const CGFloat TNHeightText = 12.0f;
static const CGFloat TNWidthCell = 306.0f;
static const CGFloat TNSideAvatar = 56.0f;
static const CGFloat TNWidthButtonLarge = 94.0f;
static const CGFloat TNWidthButtonSmall = 62.0f;
static const CGFloat TNHeightButton = 31.0f;

#define TNColorText self.blackBackground ? [UIColor whiteColor] : [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]

#define TNFontSmall [UIFont fontWithName:@"ArialMT" size:10.4f]
#define TNFontSmallBold [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]

@interface LeadCell ()

@property (nonatomic) CGFloat usedHeight;
@property (nonatomic) BOOL blackBackground;
@property (nonatomic, strong) NSObject *model;

// User
@property (nonatomic, strong) UIImageView *imageViewAvatar;
@property (nonatomic, strong) UILabel *labelUserName;
@property (nonatomic, strong) UILabel *labelUserMessage;

// Event
@property (nonatomic, strong) UIImageView *imageViewCategoryImage;
@property (nonatomic, strong) UILabel *labelCategoryTitle;
@property (nonatomic, strong) UILabel *labelPublicationTime;
@property (nonatomic, strong) SmallStakeButton *buttonEventStake;
@property (nonatomic, strong) UILabel *labelParticipants;

// Stake
@property (nonatomic, strong) UILabel *labelLine;
@property (nonatomic, strong) UILabel *labelComponents;
@property (nonatomic, strong) UILabel *labelCoefficient;
@property (nonatomic, strong) UILabel *labelCoefficientTitle;

// Tournament
@property (nonatomic, strong) UILabel *labelTournament;
@property (nonatomic, strong) UIImageView *imageViewTournamentArrow;
@property (nonatomic, strong) UIButton *buttonTournament;

// Miscelanouos
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
    [self displayParticipants:event.participants actionable:NO final:YES];
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
    if (![stake.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]])
    {
        [self displayUser:stake.user message:nil final:NO];
    }
    [self displayTournament:stake.event.tournament actionable:NO final:NO];
    [self displayCategory:stake.event.tournament.category];
    [self displayParticipants:stake.event.participants actionable:NO final:NO];
    [self displayLine:stake.line
           components:stake.components
          coefficient:stake.coefficient
                final:YES];
}

#pragma mark - Reloading

- (void)prepareForReuse
{
    self.usedHeight = 0.0f;
    self.blackBackground = NO;
    self.model = nil;
    
    // User
    [self.imageViewAvatar removeFromSuperview];
    [self.labelUserName removeFromSuperview];
    [self.labelUserMessage removeFromSuperview];
    
    // Event
    [self.imageViewCategoryImage removeFromSuperview];
    [self.labelCategoryTitle removeFromSuperview];
    [self.labelPublicationTime removeFromSuperview];
    [self.buttonEventStake removeFromSuperview];
    [self.labelParticipants removeFromSuperview];
    
    // Stake
    [self.labelLine removeFromSuperview];
    [self.labelComponents removeFromSuperview];
    [self.labelCoefficient removeFromSuperview];
    [self.labelCoefficientTitle removeFromSuperview];
    
    // Tournament
    [self.labelTournament removeFromSuperview];
    [self.imageViewTournamentArrow removeFromSuperview];
    [self.buttonTournament removeFromSuperview];
    
    // Miscelanouos
    for (UIImageView *imageView in self.delimiters)
    {
        [imageView removeFromSuperview];
    }
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
    self.labelPublicationTime = [[UILabel alloc] init];
    self.labelPublicationTime.frame = CGRectMake(
                                                 TNMarginGeneral,
                                                 TNMarginGeneral,
                                                 CGRectGetWidth(self.frame) - TNMarginGeneral * 2.0f,
                                                 TNHeightText
                                                 );
    self.labelPublicationTime.font = TNFontSmall;
    self.labelPublicationTime.backgroundColor = [UIColor clearColor];
    self.labelPublicationTime.textColor = TNColorText;
    self.labelPublicationTime.textAlignment = NSTextAlignmentRight;
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    timeIntervalFormatter.usesAbbreviatedCalendarUnits = YES;
    self.labelPublicationTime.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:time];
    [self addSubview:self.labelPublicationTime];
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
                                                TNSideAvatar,
                                                TNSideAvatar
                                               );
        [self.imageViewAvatar setImageWithURL:[user avatarWithSize:CGSizeMake(TNSideAvatar, TNSideAvatar)]];
        [self addSubview:self.imageViewAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewAvatar.frame) + TNMarginGeneral;
        self.usedHeight = CGRectGetMaxY(self.imageViewAvatar.frame);
    }
    
    // Name
    self.labelUserName = [[UILabel alloc] init];
    CGFloat userNameHeight = user.avatar && !message ? TNSideAvatar : TNHeightText;
    self.labelUserName.frame = CGRectMake(
                                          TNMarginGeneral + avatarWidth,
                                          self.usedHeight + TNMarginGeneral,
                                          TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth,
                                          userNameHeight
                                         );
    self.labelUserName.font = TNFontSmallBold;
    self.labelUserName.backgroundColor = [UIColor clearColor];
    self.labelUserName.textColor = TNColorText;
    self.labelUserName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    [self addSubview:self.labelUserName];
    
    self.usedHeight = fmax(CGRectGetMaxY(self.labelUserName.frame), CGRectGetMaxY(self.imageViewAvatar.frame));
    
    // Message
    if (message)
    {
        self.labelUserMessage = [[UILabel alloc] init];
        self.labelUserMessage.frame = CGRectMake(
                                                 TNMarginGeneral + avatarWidth,
                                                 CGRectGetMaxY(self.labelUserName.frame) + TNMarginGeneral,
                                                 TNWidthCell - TNMarginGeneral * 2.0f - avatarWidth,
                                                 CGFLOAT_MAX
                                                 );
        self.labelUserMessage.font = TNFontSmall;
        self.labelUserMessage.backgroundColor = [UIColor clearColor];
        self.labelUserMessage.textColor = TNColorText;
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
        
        [self.imageViewCategoryImage setImageWithURL:category.image];
        [self addSubview:self.imageViewCategoryImage];
        
        categoryImageWidth = CGRectGetMaxX(self.imageViewCategoryImage.frame) + TNMarginGeneral;
    }
    
    self.labelCategoryTitle = [[UILabel alloc] init];
    self.labelCategoryTitle.frame = CGRectMake(
                                               TNMarginGeneral + categoryImageWidth,
                                               self.usedHeight + TNMarginGeneral,
                                               TNWidthCell - TNMarginGeneral * 2.0f - categoryImageWidth,
                                               TNHeightText
                                               );
    self.labelCategoryTitle.font = TNFontSmall;
    self.labelCategoryTitle.backgroundColor = [UIColor clearColor];
    self.labelCategoryTitle.textColor = TNColorText;
    self.labelCategoryTitle.text = category.title;
    [self addSubview:self.labelCategoryTitle];
    
    self.usedHeight = CGRectGetMaxY(self.labelCategoryTitle.frame);
}

- (void)displayTournament:(TournamentModel *)tournament actionable:(BOOL)actionable final:(BOOL)final
{
    self.labelTournament = [[UILabel alloc] init];
    CGFloat widthLabel = actionable ? TNWidthCell - TNMarginGeneral * 3.0f - TNWidthButtonLarge : TNWidthCell - TNMarginGeneral * 2.0f;
    self.labelTournament.frame = CGRectMake(
                                                TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                widthLabel,
                                                TNHeightText
                                           );
    self.labelTournament.font = TNFontSmallBold;
    self.labelTournament.backgroundColor = [UIColor clearColor];
    self.labelTournament.textColor = TNColorText;
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
        CGFloat marginTime = self.labelPublicationTime ? [self.labelPublicationTime sizeThatFits:self.labelPublicationTime.frame.size].width + TNMarginGeneral : 0.0f;
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

- (void)displayParticipants:(NSArray *)participants actionable:(BOOL)actionable final:(BOOL)final
{
    // Participants
    self.labelParticipants = [[UILabel alloc] init];
    self.labelParticipants.frame = CGRectMake(
                                              TNMarginGeneral,
                                              self.usedHeight + TNMarginGeneral,
                                              TNWidthCell - TNMarginGeneral * 2.0f,
                                              TNHeightText
                                             );
    self.labelParticipants.font = TNFontSmallBold;
    self.labelParticipants.backgroundColor = [UIColor clearColor];
    self.labelParticipants.textColor = TNColorText;
    NSString *participantsConsolidated = @"";
    NSUInteger counter = 0;
    for (ParticipantModel *participant in participants)
    {
        if (counter == 0)
        {
            participantsConsolidated = participant.title;
        }
        else
        {
            participantsConsolidated = [NSString stringWithFormat:@"%@ — %@", participantsConsolidated, participant.title];
        }
        counter++;
    }
    self.labelParticipants.text = participantsConsolidated;
    [self addSubview:self.labelParticipants];
    
    self.usedHeight = CGRectGetMaxY(self.labelParticipants.frame);
    
    [self makeFinal:final];
}

- (void)displayLine:(LineModel *)line
         components:(NSArray *)components
        coefficient:(CoefficientModel *)coefficient
              final:(BOOL)final
{
    // Line
    self.labelLine = [[UILabel alloc] init];
    self.labelLine.frame = CGRectMake(
                                          TNMarginGeneral,
                                          self.usedHeight + TNMarginGeneral,
                                          TNWidthCell - TNMarginGeneral * 2.0f,
                                          TNHeightText
                                     );
    self.labelLine.font = TNFontSmall;
    self.labelLine.backgroundColor = [UIColor clearColor];
    self.labelLine.textColor = TNColorText;
    NSString *capitalisedLine = [[line.title lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                      withString:[[line.title  substringToIndex:1] capitalizedString]];
    self.labelLine.text = [NSString stringWithFormat:@"%@:", capitalisedLine];
    [self.labelLine sizeToFit];
    [self addSubview:self.labelLine];
    
    // Components
    self.labelComponents = [[UILabel alloc] init];
    self.labelComponents.frame = CGRectMake(
                                                CGRectGetMaxX(self.labelLine.frame) + TNMarginGeneral,
                                                self.usedHeight + TNMarginGeneral,
                                                TNWidthCell - (CGRectGetMaxX(self.labelLine.frame) + TNMarginGeneral * 3.0f),
                                                TNHeightText
                                           );
    self.labelComponents.font = TNFontSmallBold;
    self.labelComponents.backgroundColor = [UIColor clearColor];
    self.labelComponents.textColor = TNColorText;
    NSMutableString *componentsCombined = [[NSMutableString alloc] init];
    for (ComponentModel *component in components)
    {
        [componentsCombined appendFormat:@"%@ ", component.selectedCriterionObject.title];
    }
    self.labelComponents.text = [componentsCombined copy];
    [self.labelComponents sizeToFit];
    [self addSubview:self.labelComponents];
    
    // Coefficient
    NSString *coefficientString = [NSString stringWithFormat:@"Коэффициент: %.1f", coefficient.value.floatValue];
    CGPoint coefficientOrigin = CGPointMake(TNMarginGeneral, CGRectGetMaxY(self.labelLine.frame) + TNMarginGeneral);
    CGSize coefficientSize = [coefficientString sizeWithFont:TNFontSmall constrainedToSize:CGSizeMake(TNWidthCell - TNMarginGeneral * 2.0f, TNHeightText)];
    if (coefficientSize.width <= TNWidthCell - CGRectGetMaxX(self.labelComponents.frame) - TNMarginGeneral * 2.0f)
    {
        coefficientOrigin = CGPointMake(
                                        CGRectGetMaxX(self.labelComponents.frame) + TNMarginGeneral,
                                        self.usedHeight + TNMarginGeneral
                                       );
    }
    self.labelCoefficient = [[UILabel alloc] init];
    self.labelCoefficient.frame = CGRectMake(
                                             coefficientOrigin.x,
                                             coefficientOrigin.y,
                                             coefficientSize.width,
                                             coefficientSize.height
                                            );
    self.labelCoefficient.font = TNFontSmall;
    self.labelCoefficient.backgroundColor = [UIColor clearColor];
    self.labelCoefficient.textColor = TNColorText;
    self.labelCoefficient.text = coefficientString;
    [self addSubview:self.labelCoefficient];
    
    self.usedHeight = CGRectGetMaxY(self.labelCoefficient.frame);
    
    [self makeFinal:final];
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

@end
