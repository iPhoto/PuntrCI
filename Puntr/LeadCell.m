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
#import "ObjectManager.h"
#import "SmallStakeButton.h"
#import "StakeModel.h"
#import <QuartzCore/QuartzCore.h>
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

static const CGFloat TNGeneralMargin = 8.0f;
static const CGFloat TNTextHeight = 12.0f;
static const CGFloat TNCellWidth = 306.0f;
static const CGFloat TNAvatarSide = 56.0f;

#define TNColorText self.blackBackground ? [UIColor whiteColor] : [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]

#define TNFontSmall [UIFont fontWithName:@"ArialMT" size:10.4f]
#define TNFontSmallBold [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]

@interface LeadCell ()

@property (nonatomic) CGFloat usedHeight;
@property (nonatomic) BOOL blackBackground;

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

// Miscelanouos
@property (nonatomic, strong) NSMutableArray *delimiters;

@end

@implementation LeadCell

#pragma mark - Height Calculation

+ (CGSize)sizeForModel:(NSObject *)model
{
    LeadCell *cell = [[self alloc] init];
    [cell loadWithModel:model];
    return CGSizeMake(TNCellWidth, cell.usedHeight + TNGeneralMargin);
}

#pragma mark - General Loading

- (void)loadWithModel:(NSObject *)model
{
    if (!self.delimiters)
    {
        self.delimiters = [NSMutableArray array];
    }
    
    if ([model isMemberOfClass:[EventModel class]])
    {
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

- (void)loadWithEvent:(EventModel *)event
{
    
}

- (void)loadWithFeed:(FeedModel *)feed
{
    [self displayUser:feed.user message:feed.message final:YES];
}

- (void)loadWithStake:(StakeModel *)stake
{
    if (![stake.user isEqualToUser:[[ObjectManager sharedManager] loginedUser]])
    {
        [self displayUser:stake.user message:nil final:NO];
    }
    [self displayCategory:stake.event.tournament.category
             participants:stake.event.participants
                    final:NO];
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
                                                 TNGeneralMargin,
                                                 TNGeneralMargin,
                                                 CGRectGetWidth(self.frame) - TNGeneralMargin * 2.0f,
                                                 TNTextHeight
                                                 );
    self.labelPublicationTime.font = TNFontSmall;
    self.labelPublicationTime.backgroundColor = [UIColor clearColor];
    self.labelPublicationTime.textColor = TNColorText;
    self.labelPublicationTime.textAlignment = NSTextAlignmentRight;
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
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
                                                TNGeneralMargin,
                                                self.usedHeight + TNGeneralMargin,
                                                TNAvatarSide,
                                                TNAvatarSide
                                               );
        [self.imageViewAvatar setImageWithURL:[user avatarWithSize:CGSizeMake(TNAvatarSide, TNAvatarSide)]];
        [self addSubview:self.imageViewAvatar];
        
        avatarWidth = CGRectGetWidth(self.imageViewAvatar.frame) + TNGeneralMargin;
        self.usedHeight = CGRectGetMaxY(self.imageViewAvatar.frame);
    }
    
    // Name
    
    self.labelUserName = [[UILabel alloc] init];
    CGFloat userNameHeight = user.avatar && !message ? TNAvatarSide : TNTextHeight;
    self.labelUserName.frame = CGRectMake(
                                          TNGeneralMargin + avatarWidth,
                                          self.usedHeight + TNGeneralMargin,
                                          TNCellWidth - TNGeneralMargin * 2.0f - avatarWidth,
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
                                                 TNGeneralMargin + avatarWidth,
                                                 CGRectGetMaxY(self.labelUserName.frame) + TNGeneralMargin,
                                                 TNCellWidth - TNGeneralMargin * 2.0f - avatarWidth,
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

- (void)displayCategory:(CategoryModel *)category participants:(NSArray *)participants final:(BOOL)final
{
    
    CGFloat categoryImageWidth = 0.0f;
    CGSize categoryImageSize = CGSizeMake(12.0f, 12.0f);
    
    // Category
    
    if (category.image)
    {
        self.imageViewCategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                    TNGeneralMargin,
                                                                                    self.usedHeight + TNGeneralMargin,
                                                                                    categoryImageSize.width,
                                                                                    categoryImageSize.height
                                                                                   )];
        
        [self.imageViewCategoryImage setImageWithURL:category.image];
        [self addSubview:self.imageViewCategoryImage];
        
        categoryImageWidth = CGRectGetMaxX(self.imageViewCategoryImage.frame) + TNGeneralMargin;
    }
    
    self.labelCategoryTitle = [[UILabel alloc] init];
    self.labelCategoryTitle.frame = CGRectMake(
                                                   TNGeneralMargin + categoryImageWidth,
                                                   self.usedHeight + TNGeneralMargin,
                                                   TNCellWidth - TNGeneralMargin * 2.0f - categoryImageWidth,
                                                   TNTextHeight
                                              );
    self.labelCategoryTitle.font = TNFontSmall;
    self.labelCategoryTitle.backgroundColor = [UIColor clearColor];
    self.labelCategoryTitle.textColor = TNColorText;
    self.labelCategoryTitle.text = category.title;
    [self addSubview:self.labelCategoryTitle];
    
    self.usedHeight = CGRectGetMaxY(self.labelCategoryTitle.frame);
    
    // Participants
    self.labelParticipants = [[UILabel alloc] init];
    self.labelParticipants.frame = CGRectMake(
                                              TNGeneralMargin,
                                              self.usedHeight + TNGeneralMargin,
                                              TNCellWidth - TNGeneralMargin * 2.0f,
                                              TNTextHeight
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
                                          TNGeneralMargin,
                                          self.usedHeight + TNGeneralMargin,
                                          TNCellWidth - TNGeneralMargin * 2.0f,
                                          TNTextHeight
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
                                                CGRectGetMaxX(self.labelLine.frame) + TNGeneralMargin,
                                                self.usedHeight + TNGeneralMargin,
                                                TNCellWidth - (CGRectGetMaxX(self.labelLine.frame) + TNGeneralMargin * 3.0f),
                                                TNTextHeight
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
    CGPoint coefficientOrigin = CGPointMake(TNGeneralMargin, CGRectGetMaxY(self.labelLine.frame) + TNGeneralMargin);
    CGSize coefficientSize = [coefficientString sizeWithFont:TNFontSmall constrainedToSize:CGSizeMake(TNCellWidth - TNGeneralMargin * 2.0f, TNTextHeight)];
    if (coefficientSize.width <= TNCellWidth - CGRectGetMaxX(self.labelComponents.frame) - TNGeneralMargin * 2.0f)
    {
        coefficientOrigin = CGPointMake(
                                        CGRectGetMaxX(self.labelComponents.frame) + TNGeneralMargin,
                                        self.usedHeight + TNGeneralMargin
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
                                                                               self.usedHeight + TNGeneralMargin,
                                                                               TNCellWidth,
                                                                               delimiterHeight
                                                                              )];
        delimiter.image = delimiterImage;
        [self addSubview:delimiter];
        
        [self.delimiters addObject:delimiter];
        
        self.usedHeight += TNGeneralMargin + delimiterHeight;
    }
}

@end
