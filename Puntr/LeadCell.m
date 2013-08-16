//
//  LeadCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventModel.h"
#import "LeadCell.h"
#import "SmallStakeButton.h"
#import "StakeModel.h"
#import <QuartzCore/QuartzCore.h>
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

static const CGFloat TNGeneralMargin = 8.0f;

@interface LeadCell ()

@property (nonatomic) CGFloat usedHeight;
@property (nonatomic) BOOL black;

// Event
@property (nonatomic, strong) UIImageView *imageViewCategoryImage;
@property (nonatomic, strong) UILabel *labelCategoryTitle;
@property (nonatomic, strong) UILabel *labelPublicationTime;
@property (nonatomic, strong) SmallStakeButton *buttonEventStake;
@property (nonatomic, strong) UILabel *labelParticipants;
@property (nonatomic, strong) UIImageView *imageViewDelimiterEvent;

// Stake
@property (nonatomic, strong) UILabel *labelLine;
@property (nonatomic, strong) UILabel *labelComponents;
@property (nonatomic, strong) UILabel *labelCoefficient;
@property (nonatomic, strong) UILabel *labelCoefficientTitle;

@end

@implementation LeadCell

#pragma mark - General Loading

- (void)loadWithModel:(NSObject *)model
{
    if ([model isMemberOfClass:[EventModel class]])
    {
        [self loadWithEvent:(EventModel *)model];
    }
    else if ([model isMemberOfClass:[StakeModel class]])
    {
        [self loadWithStake:(StakeModel *)model];
    }
}

- (void)loadWithEvent:(EventModel *)event
{
    
}

- (void)loadWithStake:(StakeModel *)stake
{
    [self blackBackground];
    [self displayCategory:stake.event.tournament.category
             participants:stake.event.participants
                     time:stake.createdAt
                    final:NO];
    [self displayLine:stake.line
           components:stake.components
          coefficient:stake.coefficient
                final:YES];
    [self finalizeCell];
}

#pragma mark - Reloading

- (void)prepareForReuse
{
    self.usedHeight = 0.0f;
    self.black = NO;
    
    // Event
    [self.imageViewCategoryImage removeFromSuperview];
    [self.labelCategoryTitle removeFromSuperview];
    [self.labelPublicationTime removeFromSuperview];
    [self.buttonEventStake removeFromSuperview];
    [self.labelParticipants removeFromSuperview];
    [self.imageViewDelimiterEvent removeFromSuperview];
    
    // Stake
    [self.labelLine removeFromSuperview];
    [self.labelComponents removeFromSuperview];
    [self.labelCoefficient removeFromSuperview];
    [self.labelCoefficientTitle removeFromSuperview];
}

#pragma mark - Lead Components

- (void)blackBackground
{
    self.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    self.black = YES;
}

- (void)displayCategory:(CategoryModel *)category
           participants:(NSArray *)participants
                   time:(NSDate *)time
                  final:(BOOL)final
{
    // Category
    CGFloat stopLeft = TNGeneralMargin;
    CGFloat stopTop = TNGeneralMargin;
    
    CGSize categoryImageSize = CGSizeMake(12.0f, 12.0f);
    
    if (category.image)
    {
        self.imageViewCategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(stopLeft, self.usedHeight + TNGeneralMargin, categoryImageSize.width, categoryImageSize.height)];
        
        [self.imageViewCategoryImage setImageWithURL:category.image];
        
        stopLeft = CGRectGetMaxX(self.imageViewCategoryImage.frame);
        stopTop = TNGeneralMargin + CGRectGetHeight(self.imageViewCategoryImage.frame);
        
        [self addSubview:self.imageViewCategoryImage];
    }
    
    CGFloat labelWidth = 200.0f;
    
    UIColor *colorText = [UIColor whiteColor];
    
    UIFont *smallFont = [UIFont fontWithName:@"ArialMT" size:10.4f];
    UIFont *fontSmallBold = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
    
    self.labelCategoryTitle = [[UILabel alloc] init];
    self.labelCategoryTitle.frame = CGRectMake(
                                                   stopLeft == TNGeneralMargin ? stopLeft : stopLeft + TNGeneralMargin,
                                                   self.usedHeight + TNGeneralMargin,
                                                   labelWidth,
                                                   categoryImageSize.height
                                              );
    self.labelCategoryTitle.font = smallFont;
    self.labelCategoryTitle.backgroundColor = [UIColor clearColor];
    self.labelCategoryTitle.textColor = colorText;
    self.labelCategoryTitle.text = category.title;
    
    stopTop = TNGeneralMargin + CGRectGetHeight(self.labelCategoryTitle.frame);
    
    [self addSubview:self.labelCategoryTitle];
    
    // Time
    if (time)
    {
        self.labelPublicationTime = [[UILabel alloc] init];
        self.labelPublicationTime.frame = CGRectMake(
                                                     stopLeft,
                                                     self.usedHeight + TNGeneralMargin,
                                                     CGRectGetWidth(self.frame) - stopLeft - TNGeneralMargin,
                                                     categoryImageSize.height
                                                    );
        self.labelPublicationTime.font = smallFont;
        self.labelPublicationTime.backgroundColor = [UIColor clearColor];
        self.labelPublicationTime.textColor = colorText;
        self.labelPublicationTime.textAlignment = NSTextAlignmentRight;
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        self.labelPublicationTime.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:time];
        [self addSubview:self.labelPublicationTime];
    }
    else
    {
        CGSize buttonSize = CGSizeMake(62.0f, 31.0f);
        
        // Stake Button
        self.buttonEventStake = [SmallStakeButton buttonWithType:UIButtonTypeCustom];
        self.buttonEventStake.frame = CGRectMake(CGRectGetWidth(self.frame) - TNGeneralMargin - buttonSize.width, self.usedHeight + TNGeneralMargin, buttonSize.width, buttonSize.height);
        [self addSubview:self.buttonEventStake];
    }
    
    // Participants
    self.labelParticipants = [[UILabel alloc] init];
    self.labelParticipants.frame = CGRectMake(TNGeneralMargin, stopTop + TNGeneralMargin, labelWidth, categoryImageSize.height);
    self.labelParticipants.font = fontSmallBold;
    self.labelParticipants.backgroundColor = [UIColor clearColor];
    self.labelParticipants.textColor = colorText;
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
    
    stopTop = CGRectGetMaxY(self.labelParticipants.frame);
    
    [self addSubview:self.labelParticipants];
    
    self.usedHeight = stopTop + TNGeneralMargin;
    
    if (!final)
    {
        CGFloat delimiterHeight = 1.0f;
        UIImage *delimiterImage = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        
        if (self.black)
        {
            delimiterHeight = 2.0f;
            delimiterImage = [[UIImage imageNamed:@"delimiterBlack"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        }
        
        self.imageViewDelimiterEvent = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, stopTop + TNGeneralMargin, CGRectGetWidth(self.frame), delimiterHeight)];
        self.imageViewDelimiterEvent.image = delimiterImage;
        [self addSubview:self.imageViewDelimiterEvent];
        
        self.usedHeight += delimiterHeight;
    }
}

- (void)displayLine:(LineModel *)line components:(NSArray *)components coefficient:(CoefficientModel *)coefficient final:(BOOL)final
{
    // Constants
    CGFloat labelHeight = 12.0f;
    UIColor *colorText = [UIColor whiteColor];
    UIFont *fontSmall = [UIFont fontWithName:@"ArialMT" size:10.4f];
    UIFont *fontSmallBold = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
    
    // Line
    self.labelLine = [[UILabel alloc] init];
    self.labelLine.frame = CGRectMake(
                                          TNGeneralMargin,
                                          self.usedHeight + TNGeneralMargin,
                                          CGRectGetWidth(self.frame) - TNGeneralMargin * 2.0f,
                                          labelHeight
                                     );
    self.labelLine.font = fontSmall;
    self.labelLine.backgroundColor = [UIColor clearColor];
    self.labelLine.textColor = colorText;
    self.labelLine.text = [NSString stringWithFormat:@"%@:", [line.title capitalizedString]];
    [self.labelLine sizeToFit];
    [self addSubview:self.labelLine];
    
    // Components
    self.labelComponents = [[UILabel alloc] init];
    self.labelComponents.frame = CGRectMake(
                                                CGRectGetMaxX(self.labelLine.frame) + TNGeneralMargin,
                                                self.usedHeight + TNGeneralMargin,
                                                CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.labelLine.frame) + TNGeneralMargin * 2.0f),
                                                labelHeight
                                           );
    self.labelComponents.font = fontSmallBold;
    self.labelComponents.backgroundColor = [UIColor clearColor];
    self.labelComponents.textColor = colorText;
    NSMutableString *componentsCombined = [[NSMutableString alloc] init];
    for (ComponentModel *component in components)
    {
        [componentsCombined appendFormat:@"%@ ", component.selectedCriterionObject.title];
    }
    self.labelComponents.text = [componentsCombined copy];
    [self.labelComponents sizeToFit];
    [self addSubview:self.labelComponents];
    
    // Coefficient
    
}

#pragma mark - Finilize

- (void)finalizeCell
{
    self.layer.cornerRadius = 3.75f;
    self.layer.masksToBounds = YES;
}

@end
