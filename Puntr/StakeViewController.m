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

@interface StakeViewController ()

@property (nonatomic, strong, readonly) EventModel *event;
@property (nonatomic, strong) LineModel *selectedLine;
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) MoneyModel *balance;

@property (nonatomic, strong) UIImageView *imageViewTopDelimiter;
@property (nonatomic, strong) UIImageView *imageViewBottomDelimiter;

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelParticipantFirst;
@property (nonatomic, strong) UILabel *labelParticipantSecond;
@property (nonatomic, strong) UILabel *labelStatus;
@property (nonatomic, strong) UILabel *labelAmount;
@property (nonatomic, strong) UILabel *labelPrize;

@property (nonatomic, strong) UIButton *buttonBet;
@property (nonatomic, strong) UIButton *buttonStake;
@property (nonatomic, strong) UIButton *buttonPlus;
@property (nonatomic, strong) UIButton *buttonMinus;

@property (nonatomic, strong) StakeElementView *elementViewLineSelection;
@property (nonatomic, strong) StakeElementView *elementViewCriterionSelection;
@property (nonatomic, strong) StakeElementView *elementViewCoefficient;;

@property (nonatomic, strong) UITextField *textFieldAmount;

@end

@implementation StakeViewController

- (id)initWithEvent:(EventModel *)event
{
    self = [super init];
    if (self) {
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Ставка";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f, 0.0f, applicationFrame.size.width, applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    CGFloat zero = 0.0f;
    CGFloat screenWidth = 320.0f;
    CGFloat screenHeight = viewControllerFrame.size.height;
    CGFloat coverMargin = 8.0f;
    CGFloat descriptionPadding = 35.0f;
    CGFloat participantsHeight = 70.0f;
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(zero, zero, screenWidth, descriptionPadding)];
    self.labelTitle.font = font;
    self.labelTitle.backgroundColor = [UIColor clearColor];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.text = [NSString stringWithFormat:@"Ставка на %@", self.event.category.title];
    [self.view addSubview:self.labelTitle];
    
    UIView *backgroundCover = [[UIView alloc] initWithFrame:CGRectMake(coverMargin, descriptionPadding, screenWidth - coverMargin * 2.0f, screenHeight - coverMargin - descriptionPadding)];
    backgroundCover.backgroundColor = [UIColor whiteColor];
    backgroundCover.layer.cornerRadius = 3.75f;
    backgroundCover.layer.masksToBounds = YES;
    [self.view addSubview:backgroundCover];
    
    CGSize participantSize = CGSizeMake((screenWidth - 2.0f * coverMargin) / 2.0f, participantsHeight);
    CGFloat labelPadding = 20.0f;
    
    self.labelParticipantFirst = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + labelPadding, descriptionPadding, participantSize.width - labelPadding * 2.0f, participantSize.height)];
    self.labelParticipantFirst.font = font;
    self.labelParticipantFirst.backgroundColor = [UIColor clearColor];
    self.labelParticipantFirst.textAlignment = NSTextAlignmentCenter;
    self.labelParticipantFirst.numberOfLines = 0;
    self.labelParticipantFirst.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelParticipantFirst.text = [(ParticipantModel *)self.event.participants[0] title];
    [self.view addSubview:self.labelParticipantFirst];
    
    self.labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + participantSize.width - labelPadding, descriptionPadding, labelPadding * 2.0f, participantSize.height)];
    self.labelStatus.font = font;
    self.labelStatus.backgroundColor = [UIColor clearColor];
    self.labelStatus.textAlignment = NSTextAlignmentCenter;
    self.labelStatus.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelStatus.text = self.event.status ? self.event.status : @"—";
    [self.view addSubview:self.labelStatus];
    
    self.labelParticipantSecond = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin + labelPadding + participantSize.width, descriptionPadding, participantSize.width - labelPadding * 2.0f, participantSize.height)];
    self.labelParticipantSecond.font = font;
    self.labelParticipantSecond.backgroundColor = [UIColor clearColor];
    self.labelParticipantSecond.textAlignment = NSTextAlignmentCenter;
    self.labelParticipantSecond.numberOfLines = 0;
    self.labelParticipantSecond.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.labelParticipantSecond.text = [(ParticipantModel *)self.event.participants[1] title];
    [self.view addSubview:self.labelParticipantSecond];
    
    self.imageViewTopDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(coverMargin, descriptionPadding + participantSize.height, screenWidth - coverMargin * 2.0f, 1.0f)];
    self.imageViewTopDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewTopDelimiter];
    
    CGFloat stakeElementHeight = 40.0f;
    
    self.elementViewLineSelection = [[StakeElementView alloc] initWithFrame:CGRectMake(coverMargin * 2.0f, self.imageViewTopDelimiter.frame.origin.y + self.imageViewTopDelimiter.frame.size.height + coverMargin, screenWidth - coverMargin * 4.0f, stakeElementHeight)];
    [self.elementViewLineSelection loadWithTitle:@"Ставка на:" target:self action:@selector(showLineSelection:)];
    [self.view addSubview:self.elementViewLineSelection];
    
    self.elementViewCriterionSelection = [[StakeElementView alloc] initWithFrame:CGRectMake(coverMargin * 2.0f, self.elementViewLineSelection.frame.origin.y + self.elementViewLineSelection.frame.size.height + coverMargin, screenWidth - coverMargin * 4.0f, stakeElementHeight)];
    [self.elementViewCriterionSelection loadWithTitle:@"Текущий выбор:" target:self action:@selector(showCriterionSelection:)];
    [self.view addSubview:self.elementViewCriterionSelection];
    
    
    CGFloat amountPadding = 12.0f;
    CGFloat amountHeight = 39.0f;
    CGFloat labelAmountWidth = 130.0f;
    
    self.labelAmount = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin * 2.0f, self.elementViewCriterionSelection.frame.origin.y + self.elementViewCriterionSelection.frame.size.height + amountPadding, labelAmountWidth, amountHeight)];
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
    self.buttonMinus.frame = CGRectMake(self.labelAmount.frame.origin.x + self.labelAmount.frame.size.width, self.labelAmount.frame.origin.y + buttonOperationPadding, buttonOperationWidth, buttonOperationHeight);
    [self.buttonMinus setBackgroundImage:[UIImage imageNamed:@"ButtonMinus"] forState:UIControlStateNormal];
    [self.buttonMinus setBackgroundImage:[UIImage imageNamed:@"ButtonMinusSelected"] forState:UIControlStateHighlighted];
    [self.buttonMinus addTarget:self action:@selector(amountDecrease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonMinus];
    
    CGFloat amountWidth = 74.0f;
    
    self.textFieldAmount = [[UITextField alloc] initWithFrame:CGRectMake(self.buttonMinus.frame.origin.x + self.buttonMinus.frame.size.width + coverMargin, self.elementViewCriterionSelection.frame.origin.y + self.elementViewCriterionSelection.frame.size.height + amountPadding, amountWidth, amountHeight)];
    self.textFieldAmount.background = [[UIImage imageNamed:@"area"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
    self.textFieldAmount.userInteractionEnabled = NO;
    self.textFieldAmount.textAlignment = NSTextAlignmentCenter;
    self.textFieldAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldAmount.text = @"0";
    self.textFieldAmount.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [self.view addSubview:self.textFieldAmount];
    
    self.buttonPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonPlus.frame = CGRectMake(self.textFieldAmount.frame.origin.x + self.textFieldAmount.frame.size.width + coverMargin, self.labelAmount.frame.origin.y + buttonOperationPadding, buttonOperationWidth, buttonOperationHeight);
    [self.buttonPlus setBackgroundImage:[UIImage imageNamed:@"ButtonPlus"] forState:UIControlStateNormal];
    [self.buttonPlus setBackgroundImage:[UIImage imageNamed:@"ButtonPlusSelected"] forState:UIControlStateHighlighted];
    [self.buttonPlus addTarget:self action:@selector(amountIncrease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPlus];
    
    self.elementViewCoefficient = [[StakeElementView alloc] initWithFrame:CGRectMake(coverMargin * 2.0f, self.textFieldAmount.frame.origin.y + self.textFieldAmount.frame.size.height + amountPadding, screenWidth - coverMargin * 4.0f, stakeElementHeight)];
    [self.elementViewCoefficient loadWithTitle:@"Коэффициент:" target:nil action:nil];
    [self.view addSubview:self.elementViewCoefficient];
    
    CGFloat buttonHeight = 40.0f;
    
    self.labelPrize = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin * 2.0f, self.elementViewCoefficient.frame.origin.y + self.elementViewCoefficient.frame.size.height, screenWidth - 4.0f * coverMargin, (screenHeight - 3.0f * coverMargin - buttonHeight) - (self.elementViewCoefficient.frame.origin.y + self.elementViewCoefficient.frame.size.height))];
    self.labelPrize.font = font;
    self.labelPrize.backgroundColor = [UIColor clearColor];
    self.labelPrize.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    self.labelPrize.textAlignment = NSTextAlignmentCenter;
    self.labelPrize.text = @"Выигрыш:";
    [self.view addSubview:self.labelPrize];
    
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
    [self.buttonBet setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonBet];
    
    self.buttonStake = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonStake.frame = CGRectMake(coverMargin * 3.0f + (screenWidth - coverMargin * 5.0f) / 2.0f, screenHeight - 2.0f * coverMargin - buttonHeight, (screenWidth - coverMargin * 5.0f) / 2.0f, 40.0f);
    self.buttonStake.adjustsImageWhenHighlighted = NO;
    [self.buttonStake setTitle:@"Ставить" forState:UIControlStateNormal];
    self.buttonStake.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonStake.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonStake.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonStake setBackgroundImage:[[UIImage imageNamed:@"ButtonGreen"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.buttonStake addTarget:self action:@selector(stakeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonStake];
    
    [self loadBalance];
}

- (void)close {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showLineSelection:(UIControl *)sender {
    [LinePicker showPickerWithLines:self.event.lines selectedLine:self.selectedLine doneBlock:^(LinePicker *picker, LineModel *line) {
        self.selectedLine = line;
        [self.elementViewLineSelection updateResult:line.title];
        [[ObjectManager sharedManager] componentsForEvent:self.event line:self.selectedLine success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            self.components = mappingResult.array;
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
        }];
    } cancelBlock:^(LinePicker *picker) {
        
    } origin:sender];
}

- (void)showCriterionSelection:(UIControl *)sender {
    if (self.components) {
        [ComponentPicker showPickerWithComponents:self.components doneBlock:^(ComponentPicker *picker, NSArray *components) {
            self.components = components;
            NSString *result = @"";
            for (ComponentModel *component in components) {
                if (component.selectedCriterion) {
                    NSUInteger index = 0;
                    for (CriterionModel *criterion in component.criteria) {
                        if ([component.selectedCriterion isEqualToNumber:criterion.tag]) {
                            result = [NSString stringWithFormat:@"%@ %@", result, criterion.title];
                            break;
                        }
                        index++;
                    }
                }
            }
            [self.elementViewCriterionSelection updateResult:result];
            
        } cancelBlock:^(ComponentPicker *picker, NSArray *components) {
            
        } origin:sender];
    }
}

- (void)stakeButtonTouched {
    
}

- (void)amountDecrease {
    if ([self selectedAmount] - 10 >= 0) {
        self.textFieldAmount.text = @([self selectedAmount] - 10).stringValue;
    } else {
        self.textFieldAmount.text = @"0";
    }
}

- (void)amountIncrease {
    if ([self selectedAmount] + 10 <= [self balanceAmount]) {
        self.textFieldAmount.text = @([self selectedAmount] + 10).stringValue;
    } else {
        self.textFieldAmount.text = @([self balanceAmount]).stringValue;
    }
}

- (NSInteger)selectedAmount {
    return [self.textFieldAmount.text integerValue];
}

- (NSInteger)balanceAmount {
    if (self.balance) {
        return self.balance.amount.integerValue;
    } else {
        return 0;
    }
}

- (void)loadBalance {
    [[ObjectManager sharedManager] balanceWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        MoneyModel *money = (MoneyModel *)mappingResult.firstObject;
        self.balance = money;
        if (self.balance.amount.integerValue >= 200) {
            self.textFieldAmount.text = @"200";
        } else {
            self.textFieldAmount.text = self.balance.amount.stringValue;
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [NotificationManager showError:error];
    }];
}

- (void)loadSomething {
    [[ObjectManager sharedManager] componentsForEvent:self.event line:self.event.lines[0] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *components = mappingResult.array;
        ComponentModel *component = components[0];
        NSLog(@"position:%i criteria:0 tag: %ld title: %@ ", component.position.integerValue, (long)[(CriterionModel *)component.criteria[0] tag], [(CriterionModel *)component.criteria[0] title]);
        for (ComponentModel *component in components) {
            component.selectedCriterion = [(CriterionModel *)component.criteria[0] tag];
        }
        [[ObjectManager sharedManager] coefficientForEvent:self.event line:self.event.lines[0] components:components success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            CoefficientModel *coefficient = mappingResult.firstObject;
            NSLog(@"value: %@", coefficient.value.stringValue);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
        }];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

@end
