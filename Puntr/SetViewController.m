//
//  StakeViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 16.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ChooseOpponentViewController.h"
#import "ComponentPicker.h"
#import "EventModel.h"
#import "LinePicker.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "ParticipantViewController.h"
#import "SetViewController.h"
#import "StakeElementView.h"
#import "StakeModel.h"
#import "UILabel+Puntr.h"
#import "UIViewController+Puntr.h"
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD/SVProgressHUD.h>

typedef NS_ENUM(NSInteger, SetType)
{
    SetTypeBet,
    SetTypeStake
};

static const CGFloat TNCornerRadius = 3.75f;
static const CGFloat TNMarginGeneral = 8.0f;
static const CGFloat TNSideImageLarge = 60.0f;

@interface SetViewController ()

@property (nonatomic) SetType setType;
@property (nonatomic, strong, readonly) EventModel *event;
@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) LineModel *selectedLine;
@property (nonatomic, strong) CoefficientModel *coefficient;
@property (nonatomic, strong) MoneyModel *balance;

@property (nonatomic, strong) UIImageView *imageViewTopDelimiter;
@property (nonatomic, strong) UIImageView *imageViewBottomDelimiter;
@property (nonatomic, strong) UIImageView *imageViewParticipantFirst;
@property (nonatomic, strong) UIImageView *imageViewParticipantSecond;


@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelParticipantFirst;
@property (nonatomic, strong) UILabel *labelParticipantSecond;
@property (nonatomic, strong) UILabel *labelStatus;
@property (nonatomic, strong) UILabel *labelAmount;
@property (nonatomic, strong) UILabel *labelReward;

@property (nonatomic, strong) UIButton *buttonBet;
@property (nonatomic, strong) UIButton *buttonStake;
@property (nonatomic, strong) UIButton *buttonPlus;
@property (nonatomic, strong) UIButton *buttonMinus;
@property (nonatomic, strong) UIButton *buttonParticipantFirst;
@property (nonatomic, strong) UIButton *buttonParticipantSecond;

@property (nonatomic, strong) StakeElementView *elementViewLineSelection;
@property (nonatomic, strong) StakeElementView *elementViewCriterionSelection;
@property (nonatomic, strong) StakeElementView *elementViewCoefficient;

@property (nonatomic, strong) UITextField *textFieldAmount;

@end

@implementation SetViewController

+ (SetViewController *)betWithEvent:(EventModel *)event
{
    return [[self alloc] initWithBet:event];
}

+ (SetViewController *)stakeWithEvent:(EventModel *)event
{
    return [[self alloc] initWithStake:event];
}

- (id)initWithBet:(EventModel *)event
{
    self = [super init];
    if (self)
    {
        _setType = SetTypeBet;
        _event = event;
    }
    return self;
}

- (id)initWithStake:(EventModel *)event
{
    self = [super init];
    if (self)
    {
        _setType = SetTypeStake;
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.setType == SetTypeBet ? NSLocalizedString(@"Bet", nil) : NSLocalizedString(@"Stake noun", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(close)];
    CGRect viewControllerFrame = self.frame;
    
    CGFloat zero = 0.0f;
    CGFloat screenWidth = 320.0f;
    CGFloat screenHeight = CGRectGetHeight(viewControllerFrame);
    CGFloat coverMargin = 8.0f;
    CGFloat descriptionPadding = 35.0f;
    CGFloat participantsHeight = 70.0f;
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(zero, zero, screenWidth, descriptionPadding)];
    self.labelTitle.font = font;
    self.labelTitle.backgroundColor = [UIColor clearColor];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Stake on", nil), self.event.tournament.category.title];
    [self.view addSubview:self.labelTitle];
    
    UIView *backgroundCover = [[UIView alloc] initWithFrame:CGRectMake(coverMargin, descriptionPadding, screenWidth - coverMargin * 2.0f, screenHeight - coverMargin - descriptionPadding)];
    backgroundCover.backgroundColor = [UIColor whiteColor];
    backgroundCover.layer.cornerRadius = 3.75f;
    backgroundCover.layer.masksToBounds = YES;
    [self.view addSubview:backgroundCover];
    
    ParticipantModel *participantFirst = self.event.participants[0];
    ParticipantModel *participantSecond = self.event.participants.count > 1 ? self.event.participants[1] : nil;
    CGFloat marginImageFirst = 0.0f;
    CGFloat widthLabelMax = 135.0f;
    CGFloat marginImage = TNSideImageLarge + TNMarginGeneral;
    if (participantFirst.logo)
    {
        self.imageViewParticipantFirst = [[UIImageView alloc] init];
        self.imageViewParticipantFirst.frame = CGRectMake(
                                                            TNMarginGeneral,
                                                            TNMarginGeneral,
                                                            TNSideImageLarge,
                                                            TNSideImageLarge
                                                        );
        [self.imageViewParticipantFirst setImageWithURL:[participantFirst.logo URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
        [self roundCornersForView:self.imageViewParticipantFirst];
        [backgroundCover addSubview:self.imageViewParticipantFirst];
        marginImageFirst = marginImage;
    }
    
    self.labelParticipantFirst = [UILabel labelSmallBold:YES black:NO];
    self.labelParticipantFirst.frame = CGRectMake(
                                                     TNMarginGeneral + marginImageFirst,
                                                     TNMarginGeneral,
                                                     widthLabelMax - TNMarginGeneral - marginImageFirst,
                                                     TNSideImageLarge
                                                 );
    NSDictionary *underlineAttribute = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    self.labelParticipantFirst.attributedText = [[NSAttributedString alloc] initWithString:participantFirst.title attributes:underlineAttribute];
    self.labelParticipantFirst.textAlignment = NSTextAlignmentRight;
    [backgroundCover addSubview:self.labelParticipantFirst];
    
    if (self.event.status)
    {
        self.labelStatus = [UILabel labelSmallBold:YES black:NO];
        self.labelStatus.frame = CGRectMake(
                                                    widthLabelMax,
                                                    TNMarginGeneral,
                                                    CGRectGetWidth(backgroundCover.frame) - widthLabelMax * 2.0f,
                                                    TNSideImageLarge
                                                );
        self.labelStatus.text = self.event.status;
        self.labelStatus.textAlignment = NSTextAlignmentCenter;
        [backgroundCover addSubview:self.labelStatus];
    }
    
    self.buttonParticipantFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonParticipantFirst.frame = CGRectMake(
                                                   0.0f,
                                                   0.0f,
                                                   widthLabelMax,
                                                   TNSideImageLarge + TNMarginGeneral * 2.0f
                                                   );
    [self.buttonParticipantFirst addTarget:self action:@selector(showParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundCover addSubview:self.buttonParticipantFirst];
    
    if (participantSecond)
    {
        CGFloat marginImageSecond = 0.0f;
        if (participantSecond.logo)
        {
            self.imageViewParticipantSecond = [[UIImageView alloc] init];
            self.imageViewParticipantSecond.frame = CGRectMake(
                                                                 CGRectGetWidth(backgroundCover.frame) - TNMarginGeneral - TNSideImageLarge,
                                                                 TNMarginGeneral,
                                                                 TNSideImageLarge,
                                                                 TNSideImageLarge
                                                             );
            [self.imageViewParticipantSecond setImageWithURL:[participantSecond.logo URLByAppendingSize:CGSizeMake(TNSideImageLarge, TNSideImageLarge)]];
            [self roundCornersForView:self.imageViewParticipantSecond];
            [backgroundCover addSubview:self.imageViewParticipantSecond];
            marginImageSecond = marginImage;
        }
        
        self.labelParticipantSecond = [UILabel labelSmallBold:YES black:NO];
        self.labelParticipantSecond.frame = CGRectMake(
                                                          CGRectGetWidth(backgroundCover.frame) - widthLabelMax,
                                                          TNMarginGeneral,
                                                          widthLabelMax - TNMarginGeneral - marginImageSecond,
                                                          TNSideImageLarge
                                                      );
        self.labelParticipantSecond.attributedText = [[NSAttributedString alloc] initWithString:participantSecond.title attributes:underlineAttribute];
        self.labelParticipantSecond.textAlignment = NSTextAlignmentLeft;
        [backgroundCover addSubview:self.labelParticipantSecond];
        
        self.buttonParticipantSecond = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonParticipantSecond.frame = CGRectMake(
                                                        CGRectGetWidth(backgroundCover.frame) - widthLabelMax,
                                                        0.0f,
                                                        widthLabelMax,
                                                        TNSideImageLarge + TNMarginGeneral * 2.0f
                                                        );
        [self.buttonParticipantSecond addTarget:self action:@selector(showParticipant:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundCover addSubview:self.buttonParticipantSecond];
    }
    
    CGSize participantSize = CGSizeMake((screenWidth - 2.0f * coverMargin) / 2.0f, participantsHeight);
    
    self.imageViewTopDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(coverMargin, descriptionPadding + participantSize.height, screenWidth - coverMargin * 2.0f, 1.0f)];
    self.imageViewTopDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewTopDelimiter];
    
    CGFloat stakeElementHeight = 40.0f;
    
    self.elementViewLineSelection = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                                       coverMargin * 2.0f,
                                                                                       CGRectGetMaxY(self.imageViewTopDelimiter.frame) + coverMargin,
                                                                                       screenWidth - coverMargin * 4.0f,
                                                                                       stakeElementHeight
                                                                                       )];
    [self.elementViewLineSelection loadWithTitle:NSLocalizedString(@"Stake on:", nil) target:self action:@selector(showLineSelection:)];
    [self.view addSubview:self.elementViewLineSelection];
    
    self.elementViewCriterionSelection = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                                            coverMargin * 2.0f,
                                                                                            CGRectGetMaxY(self.elementViewLineSelection.frame) + coverMargin,
                                                                                            screenWidth - coverMargin * 4.0f,
                                                                                            stakeElementHeight
                                                                                            )];
    [self.elementViewCriterionSelection loadWithTitle:NSLocalizedString(@"Current selection:", nil) target:self action:@selector(showCriterionSelection:)];
    [self.view addSubview:self.elementViewCriterionSelection];
    
    
    CGFloat amountPadding = 12.0f;
    CGFloat amountHeight = 39.0f;
    CGFloat labelAmountWidth = 130.0f;
    
    self.labelAmount = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 coverMargin * 2.0f,
                                                                 CGRectGetMaxY(self.elementViewCriterionSelection.frame) + amountPadding,
                                                                 labelAmountWidth,
                                                                 amountHeight
                                                                 )];
    self.labelAmount.font = font;
    self.labelAmount.backgroundColor = [UIColor clearColor];
    self.labelAmount.textAlignment = NSTextAlignmentCenter;
    self.labelAmount.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelAmount.text = NSLocalizedString(@"Stake amount:", nil);
    [self.view addSubview:self.labelAmount];
    
    CGFloat buttonOperationPadding = 4.0f;
    CGFloat buttonOperationWidth = 29.0f;
    CGFloat buttonOperationHeight = 30.0f;
    
    self.buttonMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonMinus.frame = CGRectMake(
                                        CGRectGetMaxX(self.labelAmount.frame),
                                        CGRectGetMinY(self.labelAmount.frame) + buttonOperationPadding,
                                        buttonOperationWidth,
                                        buttonOperationHeight
                                        );
    [self.buttonMinus setBackgroundImage:[UIImage imageNamed:@"ButtonMinus"] forState:UIControlStateNormal];
    [self.buttonMinus setBackgroundImage:[UIImage imageNamed:@"ButtonMinusSelected"] forState:UIControlStateHighlighted];
    [self.buttonMinus addTarget:self action:@selector(amountDecrease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonMinus];
    
    CGFloat amountWidth = 74.0f;
    
    self.textFieldAmount = [[UITextField alloc] initWithFrame:CGRectMake(
                                                                         CGRectGetMaxX(self.buttonMinus.frame) + coverMargin,
                                                                         CGRectGetMaxY(self.elementViewCriterionSelection.frame) + amountPadding,
                                                                         amountWidth,
                                                                         amountHeight
                                                                         )];
    self.textFieldAmount.background = [[UIImage imageNamed:@"area"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
    self.textFieldAmount.userInteractionEnabled = NO;
    self.textFieldAmount.textAlignment = NSTextAlignmentCenter;
    self.textFieldAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldAmount.text = @"0";
    self.textFieldAmount.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [self.view addSubview:self.textFieldAmount];
    
    self.buttonPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonPlus.frame = CGRectMake(
                                       CGRectGetMaxX(self.textFieldAmount.frame) + coverMargin,
                                       CGRectGetMinY(self.labelAmount.frame) + buttonOperationPadding,
                                       buttonOperationWidth,
                                       buttonOperationHeight
                                       );
    [self.buttonPlus setBackgroundImage:[UIImage imageNamed:@"ButtonPlus"] forState:UIControlStateNormal];
    [self.buttonPlus setBackgroundImage:[UIImage imageNamed:@"ButtonPlusSelected"] forState:UIControlStateHighlighted];
    [self.buttonPlus addTarget:self action:@selector(amountIncrease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPlus];
    
    if (self.setType == SetTypeStake)
    {
        self.elementViewCoefficient = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                                         coverMargin * 2.0f,
                                                                                         CGRectGetMaxY(self.textFieldAmount.frame) + amountPadding,
                                                                                         screenWidth - coverMargin * 4.0f,
                                                                                         stakeElementHeight
                                                                                         )];
        [self.elementViewCoefficient loadWithTitle:NSLocalizedString(@"Odds:", nil) target:nil action:nil];
        [self.view addSubview:self.elementViewCoefficient];
    }
    
    CGFloat buttonHeight = 40.0f;
    
    CGFloat maxY = CGRectGetMaxY(self.setType == SetTypeStake ? self.elementViewCoefficient.frame : self.textFieldAmount.frame);
    
    self.labelReward = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 coverMargin * 2.0f,
                                                                 maxY,
                                                                 screenWidth - 4.0f * coverMargin,
                                                                 (screenHeight - 3.0f * coverMargin - buttonHeight) - maxY
                                                                 )];
    self.labelReward.font = font;
    self.labelReward.backgroundColor = [UIColor clearColor];
    self.labelReward.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    self.labelReward.textAlignment = NSTextAlignmentCenter;
    self.labelReward.text = NSLocalizedString(@"Prize: ", nil);
    [self.view addSubview:self.labelReward];
    
    self.imageViewBottomDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(coverMargin, screenHeight - 3.0f * coverMargin - buttonHeight, screenWidth - coverMargin * 2.0f, 1.0f)];
    self.imageViewBottomDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewBottomDelimiter];
    
    if (self.setType == SetTypeBet)
    {
        self.buttonBet = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonBet.frame = CGRectMake(coverMargin * 2.0f, screenHeight - 2.0f * coverMargin - buttonHeight, screenWidth - coverMargin * 4.0f, buttonHeight);
        [self.buttonBet setTitle:NSLocalizedString(@"Bet", nil) forState:UIControlStateNormal];
        self.buttonBet.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
        self.buttonBet.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
        self.buttonBet.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
        [self.buttonBet setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                  forState:UIControlStateNormal];
        [self.buttonBet addTarget:self action:@selector(betButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.buttonBet];
    }
    else
    {
        self.buttonStake = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonStake.frame = CGRectMake(coverMargin * 2.0f, screenHeight - 2.0f * coverMargin - buttonHeight, screenWidth - coverMargin * 4.0f, buttonHeight);
        [self.buttonStake setTitle:NSLocalizedString(@"Stake", nil) forState:UIControlStateNormal];
        self.buttonStake.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
        self.buttonStake.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
        self.buttonStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
        [self.buttonStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreen"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                    forState:UIControlStateNormal];
        [self.buttonStake addTarget:self action:@selector(stakeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.buttonStake];
    }
    
    [self loadLines];
    [self loadBalance];
}

- (void)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data Loading

- (void)roundCornersForView:(UIView *)view
{
    view.layer.cornerRadius = TNCornerRadius;
    view.layer.masksToBounds = YES;
}

- (void)loadLines
{
    [SVProgressHUD show];
    if (self.setType == SetTypeBet)
    {
        [[ObjectManager sharedManager] betLinesForEvent:self.event
                                                success:^(NSArray *lines)
                                                {
                                                    self.lines = lines;
                                                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Lines loaded", nil)];
                                                }
                                                failure:^
                                                {
                                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Lines not loaded", nil)];
                                                }
        ];
    }
    else
    {
        [[ObjectManager sharedManager] stakeLinesForEvent:self.event
                                                  success:^(NSArray *lines)
                                                  {
                                                      self.lines = lines;
                                                      [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Lines loaded", nil)];
                                                  }
                                                  failure:^
                                                  {
                                                      [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Lines not loaded", nil)];
                                                  }
        ];
    }
}

- (void)showLineSelection:(UIControl *)sender
{
    [LinePicker showPickerWithLines:self.lines selectedLine:self.selectedLine doneBlock:^(LinePicker *picker, LineModel *line)
        {
            self.selectedLine = line;
            [self.elementViewLineSelection updateResult:line.title];
        }
        cancelBlock:nil
        origin:sender
    ];
}

- (void)showCriterionSelection:(UIControl *)sender
{
    if (self.selectedLine.components)
    {
        [ComponentPicker showPickerWithComponents:self.selectedLine.components
                                        doneBlock:^(ComponentPicker *picker, NSArray *components)
                                        {
                                            self.selectedLine.components = components;
                                            NSString *result = @"";
                                            for (ComponentModel * component in components)
                                            {
                                                if (component.selectedCriterion)
                                                {
                                                    NSUInteger index = 0;
                                                    for (CriterionModel * criterion in component.criteria)
                                                    {
                                                        if ([component.selectedCriterion isEqualToNumber:criterion.tag])
                                                        {
                                                            result = [NSString stringWithFormat:@"%@ %@", result, criterion.title];
                                                            break;
                                                        }
                                                        index++;
                                                    }
                                                }
                                            }
                                            [self.elementViewCriterionSelection updateResult:result];
                                            [self updateCoefficient];
                                        }
                                      cancelBlock:nil
                                           origin:sender
        ];
    }
}

- (void)stakeButtonTouched
{
    if ([self stakeIsComplete])
    {
        StakeModel *stake = [self generateStake];
        [[ObjectManager sharedManager] setStake:stake success:^(StakeModel *stake)
            {
                [NotificationManager showSuccessMessage:@"Ура! Ставка сделана!" forViewController:[PuntrUtilities mainNavigationController]];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            failure:nil
        ];
    }
}

- (void)betButtonTouched
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ChooseOpponentViewController alloc] init]] animated:YES completion:nil];
}

- (BOOL)stakeIsComplete
{
    if ([self selectedAmount] == 0)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Set amount of stake", nil)];
        return NO;
    }
    if (!self.selectedLine)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Select the line of stake", nil)];
        return NO;
    }
    if (!self.coefficient)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Select the criteria of stake", nil)];
        return NO;
    }
    return YES;
}

- (StakeModel *)generateStake
{
    return [StakeModel stakeWithEvent:self.event
                                 line:self.selectedLine
                          coefficient:self.coefficient
                                money:[self selectedMoney]];
}

- (void)amountDecrease
{
    if ([self selectedAmount] - 10 >= 0)
    {
        self.textFieldAmount.text = @([self selectedAmount] - 10).stringValue;
    }
    else
    {
        self.textFieldAmount.text = @"0";
    }
    [self updateReward];
}

- (void)amountIncrease
{
    if ([self selectedAmount] + 10 <= [self balanceAmount])
    {
        self.textFieldAmount.text = @([self selectedAmount] + 10).stringValue;
    }
    else
    {
        self.textFieldAmount.text = @([self balanceAmount]).stringValue;
    }
    [self updateReward];
}

- (NSInteger)selectedAmount
{
    return [self.textFieldAmount.text integerValue];
}

- (MoneyModel *)selectedMoney
{
    MoneyModel *money = [MoneyModel moneyWithAmount:@([self selectedAmount])];
    return money;
}

- (NSInteger)balanceAmount
{
    if (self.balance)
    {
        return self.balance.amount.integerValue;
    }
    else
    {
        return 0;
    }
}

- (void)updateReward
{
    NSNumberFormatter *twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
    [twoDecimalPlacesFormatter setMaximumFractionDigits:2];
    [twoDecimalPlacesFormatter setMinimumFractionDigits:0];
    CGFloat coefficient = self.setType == SetTypeBet ? 1.9f : self.coefficient.value.floatValue;
    NSInteger rewardValue = self.textFieldAmount.text.integerValue * coefficient;
    self.labelReward.text = [NSString stringWithFormat:@"%@%@ P", NSLocalizedString(@"Prize: ", nil), [twoDecimalPlacesFormatter stringFromNumber:@(rewardValue)]];
}

- (void)updateCoefficient
{
    [[ObjectManager sharedManager] coefficientForEvent:self.event
                                                  line:self.selectedLine
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
        {
            CoefficientModel *coefficient = (CoefficientModel *)mappingResult.firstObject;
            self.coefficient = coefficient;
            NSNumberFormatter *twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
            [twoDecimalPlacesFormatter setMaximumFractionDigits:2];
            [twoDecimalPlacesFormatter setMinimumFractionDigits:0];
            [self.elementViewCoefficient updateResult:[twoDecimalPlacesFormatter stringFromNumber:coefficient.value]];
            [self updateReward];
        }
                                               failure:nil
    ];
}

- (void)loadBalance
{
    [[ObjectManager sharedManager] balanceWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
        {
            MoneyModel *money = (MoneyModel *)mappingResult.firstObject;
            self.balance = money;
            if (self.balance.amount.integerValue >= 200)
            {
                self.textFieldAmount.text = @"200";
            }
            else
            {
                self.textFieldAmount.text = self.balance.amount.stringValue;
            }
            [self updateReward];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error)
        {
            [NotificationManager showError:error];
        }
    ];
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

@end
