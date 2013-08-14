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
#import <TTTTimeIntervalFormatter.h>
#import <UIImageView+AFNetworking.h>

@interface LeadCell ()

@property (nonatomic) CGFloat usedHeight;
@property (nonatomic, readonly) CGFloat generalMargin;
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _generalMargin = 8.0f;
    }
    return self;
}

#pragma mark - General Loading

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
    CGFloat stopLeft = self.generalMargin;
    CGFloat stopTop = self.generalMargin;
    
    CGSize categoryImageSize = CGSizeMake(12.0f, 12.0f);
    
    if (category.image)
    {
        self.imageViewCategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(stopLeft, self.usedHeight + self.generalMargin, categoryImageSize.width, categoryImageSize.height)];
        
        [self.imageViewCategoryImage setImageWithURL:category.image];
        
        stopLeft = CGRectGetMaxX(self.imageViewCategoryImage.frame);
        stopTop = self.generalMargin + CGRectGetHeight(self.imageViewCategoryImage.frame);
        
        [self addSubview:self.imageViewCategoryImage];
    }
    
    CGFloat labelWidth = 200.0f;
    
    UIColor *colorText = [UIColor colorWithWhite:0.200 alpha:1.000];
    
    UIFont *smallFont = [UIFont fontWithName:@"ArialMT" size:10.4f];
    UIFont *fontSmallBold = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
    
    self.labelCategoryTitle = [[UILabel alloc] init];
    self.labelCategoryTitle.frame = CGRectMake(stopLeft + self.generalMargin, self.usedHeight + self.generalMargin, labelWidth, categoryImageSize.height);
    self.labelCategoryTitle.font = smallFont;
    self.labelCategoryTitle.backgroundColor = [UIColor clearColor];
    self.labelCategoryTitle.textColor = colorText;
    self.labelCategoryTitle.text = category.title;
    
    stopTop = self.generalMargin + CGRectGetHeight(self.labelCategoryTitle.frame);
    
    [self addSubview:self.labelCategoryTitle];
    
    // Time
    if (time)
    {
        self.labelPublicationTime = [[UILabel alloc] init];
        self.labelPublicationTime.frame = CGRectMake(stopLeft, self.usedHeight + self.generalMargin, CGRectGetWidth(self.frame) - stopLeft - self.generalMargin, categoryImageSize.height);
        self.labelPublicationTime.font = smallFont;
        self.labelPublicationTime.backgroundColor = [UIColor clearColor];
        self.labelPublicationTime.textColor = colorText;
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        self.labelPublicationTime.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:time];
        [self addSubview:self.labelPublicationTime];
    }
    else
    {
        CGSize buttonSize = CGSizeMake(62.0f, 31.0f);
        
        // Stake Button
        self.buttonEventStake = [SmallStakeButton buttonWithType:UIButtonTypeCustom];
        self.buttonEventStake.frame = CGRectMake(CGRectGetWidth(self.frame) - self.generalMargin - buttonSize.width, self.usedHeight + self.generalMargin, buttonSize.width, buttonSize.height);
        [self addSubview:self.buttonEventStake];
    }
    
    // Participants
    self.labelParticipants = [[UILabel alloc] init];
    self.labelParticipants.frame = CGRectMake(self.generalMargin, stopTop + self.generalMargin, labelWidth, categoryImageSize.height);
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
            participantsConsolidated = [NSString stringWithFormat:@"%@ — %@", participants, participant.title];
        }
        counter++;
    }
    self.labelParticipants.text = participantsConsolidated;
    
    stopTop = CGRectGetMaxY(self.labelParticipants.frame);
    
    [self addSubview:self.labelParticipants];
    
    self.usedHeight = stopTop + self.generalMargin;
    
    if (!final)
    {
        CGFloat delimiterHeight = 1.0f;
        UIImage *delimiterImage = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        
        if (self.black)
        {
            delimiterHeight = 2.0f;
            delimiterImage = [[UIImage imageNamed:@"delimiterBlack"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        }
        
        self.imageViewDelimiterEvent = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, stopTop + self.generalMargin, CGRectGetWidth(self.frame), delimiterHeight)];
        self.imageViewDelimiterEvent.image = delimiterImage;
        [self addSubview:self.imageViewDelimiterEvent];
        
        self.usedHeight += delimiterHeight;
    }
}

- (void)displayLine:(LineModel *)line components:(NSArray *)components coefficient:(CoefficientModel *)coefficient final:(BOOL)final
{
    CGFloat labelHeight = 12.0f;
    
    UIColor *colorText = [UIColor colorWithWhite:0.200 alpha:1.000];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    UIFont *fontSmall = [UIFont fontWithName:@"ArialMT" size:10.4f];
    UIFont *fontSmallBold = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
#pragma clang diagnostic pop
    self.labelLine = [[UILabel alloc] init];
    self.labelLine.frame = CGRectMake(self.generalMargin, self.usedHeight + self.generalMargin, CGRectGetWidth(self.frame), labelHeight);
    self.labelLine.font = fontSmall;
    self.labelLine.backgroundColor = [UIColor clearColor];
    self.labelLine.textColor = colorText;
    self.labelLine.text = [NSString stringWithFormat:@"%@:", [line.title uppercaseString]];
    [self addSubview:self.labelLine];
}

@end
