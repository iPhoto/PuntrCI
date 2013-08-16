//
//  StakeViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 16.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "StakeViewController.h"
#import "StakeModel.h"
#import "EventModel.h"
#import "StakeElementView.h"
#import "ObjectManager.h"
#import <QuartzCore/QuartzCore.h>
#import "ComponentPicker.h"
#import "LinePicker.h"
#import "NotificationManager.h"
#import "ParticipantViewController.h"

@interface StakeViewController ()

@property (nonatomic, strong, readonly) EventModel *event;
@property (nonatomic, strong) LineModel *selectedLine;
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) CoefficientModel *coefficient;
@property (nonatomic, strong) MoneyModel *balance;

@property (nonatomic, strong) UIImageView *imageViewTopDelimiter;
@property (nonatomic, strong) UIImageView *imageViewBottomDelimiter;

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

@implementation StakeViewController

- (id)initWithEvent:(EventModel *)event
{
    self = [super init];
    if (self)
    {
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Ставка";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(close)];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds)
                                            );
    
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
    self.labelTitle.text = [NSString stringWithFormat:@"Ставка на %@", self.event.tournament.category.title];
    [self.view addSubview:self.labelTitle];
    
    UIView *backgroundCover = [[UIView alloc] initWithFrame:CGRectMake(coverMargin, descriptionPadding, screenWidth - coverMargin * 2.0f, screenHeight - coverMargin - descriptionPadding)];
    backgroundCover.backgroundColor = [UIColor whiteColor];
    backgroundCover.layer.cornerRadius = 3.75f;
    backgroundCover.layer.masksToBounds = YES;
    [self.view addSubview:backgroundCover];
    
    CGSize participantSize = CGSizeMake((screenWidth - 2.0f * coverMargin) / 2.0f, participantsHeight);
    CGFloat labelPadding = 20.0f;
    
    self.buttonParticipantFirst = [[UIButton alloc] initWithFrame:CGRectMake(2 * coverMargin, descriptionPadding + 13, 128, 44)];
    [self.buttonParticipantFirst setBackgroundImage:[[UIImage imageNamed:@"ButtonGray"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)]
                                           forState:UIControlStateNormal];
    self.buttonParticipantFirst.titleLabel.font = font;
    self.buttonParticipantFirst.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonParticipantFirst.titleLabel.numberOfLines = 0;
    [self.buttonParticipantFirst setTitleColor:[UIColor colorWithWhite:0.200 alpha:1.000] forState:UIControlStateNormal];
    [self.buttonParticipantFirst setTitle:[(ParticipantModel *)self.event.participants[0] title] forState:UIControlStateNormal];
    [self.buttonParticipantFirst addTarget:self action:@selector(showParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonParticipantFirst];
    
    self.labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + participantSize.width - labelPadding, descriptionPadding, labelPadding * 2.0f, participantSize.height)];
    self.labelStatus.font = font;
    self.labelStatus.backgroundColor = [UIColor clearColor];
    self.labelStatus.textAlignment = NSTextAlignmentCenter;
    self.labelStatus.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelStatus.text = self.event.status ? self.event.status : @"—";
    [self.view addSubview:self.labelStatus];
    
    self.buttonParticipantSecond = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - (2 * coverMargin + 128), descriptionPadding + 13, 128, 44)];
    [self.buttonParticipantSecond setBackgroundImage:[[UIImage imageNamed:@"ButtonGray"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)]
                                            forState:UIControlStateNormal];
    self.buttonParticipantSecond.titleLabel.font = font;
    self.buttonParticipantSecond.titleLabel.backgroundColor = [UIColor clearColor];
    self.buttonParticipantSecond.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonParticipantSecond.titleLabel.numberOfLines = 0;
    [self.buttonParticipantSecond setTitleColor:[UIColor colorWithWhite:0.200 alpha:1.000] forState:UIControlStateNormal];
    [self.buttonParticipantSecond setTitle:[(ParticipantModel *)self.event.participants[1] title] forState:UIControlStateNormal];
    [self.buttonParticipantSecond addTarget:self action:@selector(showParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonParticipantSecond];
    
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
    [self.elementViewLineSelection loadWithTitle:@"Ставка на:" target:self action:@selector(showLineSelection:)];
    [self.view addSubview:self.elementViewLineSelection];
    
    self.elementViewCriterionSelection = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                                            coverMargin * 2.0f,
                                                                                            CGRectGetMaxY(self.elementViewLineSelection.frame) + coverMargin,
                                                                                            screenWidth - coverMargin * 4.0f,
                                                                                            stakeElementHeight
                                                                                            )];
    [self.elementViewCriterionSelection loadWithTitle:@"Текущий выбор:" target:self action:@selector(showCriterionSelection:)];
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
    self.labelAmount.text = @"Сумма ставки:";
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
    
    self.elementViewCoefficient = [[StakeElementView alloc] initWithFrame:CGRectMake(
                                                                                     coverMargin * 2.0f,
                                                                                     CGRectGetMaxY(self.textFieldAmount.frame) + amountPadding,
                                                                                     screenWidth - coverMargin * 4.0f,
                                                                                     stakeElementHeight
                                                                                     )];
    [self.elementViewCoefficient loadWithTitle:@"Коэффициент:" target:nil action:nil];
    [self.view addSubview:self.elementViewCoefficient];
    
    CGFloat buttonHeight = 40.0f;
    
    self.labelReward = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 coverMargin * 2.0f,
                                                                 CGRectGetMaxY(self.elementViewCoefficient.frame),
                                                                 screenWidth - 4.0f * coverMargin,
                                                                 (screenHeight - 3.0f * coverMargin - buttonHeight) - CGRectGetMaxY(self.elementViewCoefficient.frame)
                                                                 )];
    self.labelReward.font = font;
    self.labelReward.backgroundColor = [UIColor clearColor];
    self.labelReward.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    self.labelReward.textAlignment = NSTextAlignmentCenter;
    self.labelReward.text = @"Выигрыш: ";
    [self.view addSubview:self.labelReward];
    
    self.imageViewBottomDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(coverMargin, screenHeight - 3.0f * coverMargin - buttonHeight, screenWidth - coverMargin * 2.0f, 1.0f)];
    self.imageViewBottomDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewBottomDelimiter];
    
    self.buttonBet = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonBet.frame = CGRectMake(coverMargin * 2.0f, screenHeight - 2.0f * coverMargin - buttonHeight, (screenWidth - coverMargin * 5.0f) / 2.0f, buttonHeight);
    self.buttonBet.adjustsImageWhenHighlighted = NO;
    [self.buttonBet setTitle:@"Пари" forState:UIControlStateNormal];
    self.buttonBet.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonBet.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonBet.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonBet setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                              forState:UIControlStateNormal];
    [self.view addSubview:self.buttonBet];
    
    self.buttonStake = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonStake.frame = CGRectMake(coverMargin * 3.0f + (screenWidth - coverMargin * 5.0f) / 2.0f, screenHeight - 2.0f * coverMargin - buttonHeight, (screenWidth - coverMargin * 5.0f) / 2.0f, 40.0f);
    self.buttonStake.adjustsImageWhenHighlighted = NO;
    [self.buttonStake setTitle:@"Ставить" forState:UIControlStateNormal];
    self.buttonStake.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonStake.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreen"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                forState:UIControlStateNormal];
    [self.buttonStake addTarget:self action:@selector(stakeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonStake];
    
    [self loadBalance];
}

- (void)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLineSelection:(UIControl *)sender
{
    [LinePicker showPickerWithLines:self.event.lines selectedLine:self.selectedLine doneBlock:^(LinePicker *picker, LineModel *line)
        {
            self.selectedLine = line;
            [self.elementViewLineSelection updateResult:line.title];
            [[ObjectManager sharedManager] componentsForEvent:self.event
                                                         line:self.selectedLine
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                                      {
                                                          self.components = mappingResult.array;
                                                      }
                                                      failure:nil
            ];
        }
        cancelBlock:nil
        origin:sender
    ];
}

- (void)showCriterionSelection:(UIControl *)sender
{
    if (self.components)
    {
        [ComponentPicker showPickerWithComponents:self.components
                                        doneBlock:^(ComponentPicker *picker, NSArray *components)
                                        {
                                            self.components = components;
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
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            failure:nil
        ];
    }
}

- (BOOL)stakeIsComplete
{
    if ([self selectedAmount] == 0)
    {
        [NotificationManager showNotificationMessage:@"Задайте сумму ставки"];
        return NO;
    }
    if (!self.selectedLine)
    {
        [NotificationManager showNotificationMessage:@"Выберите линию ставки"];
        return NO;
    }
    if (!self.coefficient)
    {
        [NotificationManager showNotificationMessage:@"Выберите критерии ставки"];
        return NO;
    }
    return YES;
}

- (StakeModel *)generateStake
{
    return [StakeModel stakeWithEvent:self.event
                                 line:self.selectedLine
                           components:self.components
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
    self.labelReward.text = [NSString stringWithFormat:@"Выигрыш: %@ Р", [twoDecimalPlacesFormatter stringFromNumber:@(self.textFieldAmount.text.integerValue * self.coefficient.value.floatValue)]];
}

- (void)updateCoefficient
{
    [[ObjectManager sharedManager] coefficientForEvent:self.event
                                                  line:self.selectedLine
                                            components:self.components
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
    [self.navigationController pushViewController:[[ParticipantViewController alloc] initWithParticipant:self.event.participants[i]] animated:YES];
}

@end
