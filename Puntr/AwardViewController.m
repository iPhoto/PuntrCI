//
//  AwardViewController.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardViewController.h"


#define EDGE_VIEWS  16.0f
@interface AwardViewController () <UITextFieldDelegate>

@property (nonatomic, retain) AwardModel *award;

@property (nonatomic, retain) UIImageView *awardImageView;
@property (nonatomic, retain) UILabel *awardTitleLabel;
@property (nonatomic, retain) UITextField *awardComment;
@property (nonatomic, retain) UIButton *shareAwardButton;

@end

@implementation AwardViewController

- (id)initWithAward:(AwardModel *)award
{
    if (self = [super init])
    {
        _award = award;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat coverMargin = 8.0f;
    
    self.awardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(EDGE_VIEWS, EDGE_VIEWS, 296.0f, 296.0f)];
    self.awardImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.awardImageView];
    
    CGFloat labelX = CGRectGetMaxX(self.awardImageView.frame) + EDGE_VIEWS;
    CGFloat labelWidth = self.view.frame.size.width - labelX;
    
    CGSize labelSize = [self.award.title sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.0f] forWidth:labelWidth lineBreakMode:NSLineBreakByWordWrapping];
    self.awardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetMidY(self.awardImageView.frame), labelWidth, labelSize.height)];
    self.awardTitleLabel.text = self.award.title;
    [self.view addSubview:self.awardTitleLabel];
    
    self.awardComment = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.awardImageView.frame), CGRectGetMaxY(self.awardImageView.frame) + EDGE_VIEWS, self.view.frame.size.width - (2 * coverMargin), labelSize.height)];
    self.awardComment.placeholder = @"Ваш комментарий";
    self.awardComment.textAlignment = NSTextAlignmentLeft;
    self.awardComment.contentVerticalAlignment  = UIControlContentHorizontalAlignmentCenter;
    self.awardComment.delegate = self;
    [self.view addSubview:self.awardComment];
    
    self.shareAwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareAwardButton.frame = CGRectMake(CGRectGetMinX(self.awardImageView.frame), CGRectGetMaxY(self.awardComment.frame) + EDGE_VIEWS, self.view.frame.size.width - (2 * coverMargin), labelSize.height);
    [self.shareAwardButton setTitle:@"Поделиться" forState:UIControlStateNormal];
    [self.shareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareAwardButton];
}

- (void)shareAwardButtonAction:(UIButton *)button {
    //
}


@end
