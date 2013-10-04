//
//  BetViewController.m
//  Puntr
//
//  Created by Artem on 9/25/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "BetViewController.h"
#import "UILabel+Puntr.h"
#import "LeadCell.h"
#import "ObjectManager.h"


//static const CGFloat TNMarginGeneral = 8.0f;
//static const CGFloat TNWidthCell = 306.0f;
//static const CGFloat TNHeightText = 12.0f;


@interface BetViewController ()

@property (nonatomic, strong) BetModel *bet;
//@property (nonatomic) CGFloat usedHeight;
//@property (nonatomic) BOOL blackBackground;
@property (nonatomic, strong) LeadCell *leadCell;

@end

@implementation BetViewController

- (id)init {
    if (self = [self initWithNibName:nil bundle:nil]) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _blackBackground = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //CGFloat coverMargin = 8.0f;
    
    self.view.frame = CGRectMake(0.0f, 0.0f, 300.0f, 280.0f);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    UIFont *titleFont = [UIFont fontWithName:@"Arial-BoldMT" size:14.0f];
    UILabel *controllerTitleLabel = [UILabel labelSmallBold:YES black:YES];
    controllerTitleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    controllerTitleLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    controllerTitleLabel.font = titleFont;
    controllerTitleLabel.textColor = [UIColor whiteColor];
    controllerTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    controllerTitleLabel.numberOfLines = 0;
    controllerTitleLabel.contentMode = UIViewContentModeCenter;
    controllerTitleLabel.textAlignment = NSTextAlignmentCenter;
    controllerTitleLabel.text = NSLocalizedString(@"Bet", nil);
    [self.view addSubview:controllerTitleLabel];
    
//    [self displayCategory:self.bet.event.tournament.category];
    
    self.leadCell = [[LeadCell alloc] initWithFrame:CGRectMake(0, controllerTitleLabel.frame.size.height, self.view.frame.size.width, 200)];
    [self.view addSubview:self.leadCell];
    [self.leadCell loadWithModel:self.bet];
    
    CGFloat buttonHeight = 40;
    CGFloat coverMargin = 8;
    CGFloat buttonWidth = (self.view.frame.size.width - coverMargin * 8.0f) / 2.0f;
    
    UIButton *buttonOk = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOk.frame = CGRectMake(coverMargin * 2.0f, self.view.frame.size.height - buttonHeight - coverMargin, buttonWidth, buttonHeight);
    [buttonOk setTitle:NSLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
    buttonOk.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    buttonOk.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    buttonOk.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonOk setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                        forState:UIControlStateNormal];
    [buttonOk addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOk];
    
    
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.frame = CGRectMake(self.view.frame.size.width - (coverMargin * 2) - buttonWidth, self.view.frame.size.height - buttonHeight - coverMargin, buttonWidth, buttonHeight);
    [buttonCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    buttonCancel.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    buttonCancel.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonCancel setBackgroundImage:[[UIImage imageNamed:@"ButtonGreen"]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                            forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCancel];
}

- (void)setupWithBet:(BetModel *)bet
{
    self.bet = bet;
}

- (void)acceptButtonPressed:(UIButton *)sender
{
    [[ObjectManager sharedManager] acceptBet:self.bet success:^{
    } failure:^{
    }];
}

- (void)cancelButtonPressed:(UIButton *)sender
{
}

/*
- (void)displayCategory:(CategoryModel *)category
{
    CGFloat categoryImageWidth = 0.0f;
    CGSize categoryImageSize = CGSizeMake(12.0f, 12.0f);
    
    CGFloat TNMarginCategoryImage = 7.0f;
    
    if (category.image)
    {
        UIImageView *imageViewCategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                    TNMarginGeneral,
                                                                                    self.usedHeight + TNMarginCategoryImage,
                                                                                    categoryImageSize.width,
                                                                                    categoryImageSize.height
                                                                                    )];
        [imageViewCategoryImage setImageWithURL:[category.image URLByAppendingSize:categoryImageSize]];
        [self.view addSubview:imageViewCategoryImage];
        
        categoryImageWidth = CGRectGetMaxX(imageViewCategoryImage.frame);
    }
    
    CGFloat TNMarginCategoryTitle = 4.0f;
    
    UILabel *labelCategoryTitle = [UILabel labelSmallBold:NO black:self.blackBackground];
    labelCategoryTitle.frame = CGRectMake(
                                               TNMarginCategoryTitle + categoryImageWidth,
                                               self.usedHeight + TNMarginGeneral,
                                               TNWidthCell - TNMarginGeneral * 2.0f - categoryImageWidth,
                                               TNHeightText
                                               );
    labelCategoryTitle.text = category.title;
    [self.view addSubview:labelCategoryTitle];
    
    CGFloat maxY = CGRectGetMaxY(labelCategoryTitle.frame);
//    [self placeButtonForObject:[self tournamentOrEvent] maxY:maxY];
    
    self.usedHeight = maxY;
}*/


@end
