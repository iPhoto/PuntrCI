//
//  AwardViewController.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardViewController.h"
#import "SocialManager.h"

#define EDGE_VIEWS  8.0f

@interface AwardViewController () <UITextFieldDelegate>

@property (nonatomic, retain) AwardModel *award;

@property (nonatomic, retain) UIImageView *awardImageView;
@property (nonatomic, retain) UILabel *controllerTitleLabel;
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
    
    self.view.frame = CGRectMake(0.0f, 0.0f, 280.0f, 280.0f);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    NSString *controllerTitle = @"Поздравляем, Вы получили новый бейдж!";
    UIFont *titleFont = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
    CGSize titleSize = [controllerTitle sizeWithFont:titleFont forWidth:CGRectGetWidth(self.view.frame) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.controllerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, coverMargin, titleSize.width, titleSize.height)];
    self.controllerTitleLabel.center = CGPointMake(self.view.center.x, self.controllerTitleLabel.center.y);
    self.controllerTitleLabel.backgroundColor = [UIColor clearColor];
    self.controllerTitleLabel.font = titleFont;
    self.controllerTitleLabel.textColor = [UIColor whiteColor];
    self.controllerTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.controllerTitleLabel.numberOfLines = 0;
    self.controllerTitleLabel.contentMode = UIViewContentModeCenter;
    self.controllerTitleLabel.text = controllerTitle;
    [self.view addSubview:self.controllerTitleLabel];
    
    CGFloat imageSide = 120.0f;
    self.awardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(EDGE_VIEWS, EDGE_VIEWS, imageSide, imageSide)];
    self.awardImageView.backgroundColor = [UIColor clearColor];
//    CGSize awardImageSize = CGSizeMake(imageSide, imageSide);
//    [self.awardImageView setImageWithURL:[self.award.image URLByAppendingSize:awardImageSize]];
    [self.awardImageView setImageWithURL:self.award.image];
    self.awardImageView.center = CGPointMake(self.view.center.x, (imageSide / 2) + EDGE_VIEWS + CGRectGetMaxY(self.controllerTitleLabel.frame));
    [self.view addSubview:self.awardImageView];
    
    CGFloat labelX = 0.0f;//CGRectGetMaxX(self.awardImageView.frame) + EDGE_VIEWS;
    CGFloat labelWidth = self.view.frame.size.width - labelX;// - EDGE_VIEWS;
    
    CGSize labelSize = [self.award.title sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0f] constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    self.awardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetMaxY(self.awardImageView.frame) + EDGE_VIEWS, labelWidth, labelSize.height)];
    self.awardTitleLabel.backgroundColor = [UIColor clearColor];
    self.awardTitleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
    
    self.awardTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.awardTitleLabel.contentMode = UIViewContentModeCenter;
    self.awardTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.awardTitleLabel.numberOfLines = 0;
    self.awardTitleLabel.text = self.award.title;
    [self.view addSubview:self.awardTitleLabel];
    
    labelX += labelWidth / 2;
    
    
//    self.awardComment = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.awardImageView.frame), CGRectGetMaxY(self.awardImageView.frame) + EDGE_VIEWS, self.view.frame.size.width - (2 * coverMargin), labelSize.height)];
//    self.awardComment.placeholder = @"Ваш комментарий";
//    self.awardComment.textAlignment = NSTextAlignmentLeft;
//    self.awardComment.returnKeyType = UIReturnKeyDone;
//    self.awardComment.contentVerticalAlignment  = UIControlContentHorizontalAlignmentCenter;
//    self.awardComment.delegate = self;
//    [self.view addSubview:self.awardComment];
   
    labelSize = [@"Поделиться" sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.0f] constrainedToSize:CGSizeMake(self.view.frame.size.width - (2 * coverMargin) - CGRectGetMinX(self.awardImageView.frame), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    self.shareAwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareAwardButton.frame = CGRectMake(coverMargin, CGRectGetMaxY(self.awardTitleLabel.frame) + EDGE_VIEWS, self.view.frame.size.width - (2 * coverMargin), 2 * labelSize.height);
    self.shareAwardButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    [self.shareAwardButton setTitle:@"Поделиться" forState:UIControlStateNormal];
    [self.shareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareAwardButton];
}

- (void)shareAwardButtonAction:(UIButton *)button {
    //
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose an Account"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    
    [sheet addButtonWithTitle:@"Facebook"];
    [sheet addButtonWithTitle:@"Twitter"];
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
//    [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    [sheet showInView:self.view];
}

- (BOOL)becomeFirstResponder {
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self presentViewController:[[SocialManager sharedManager] shareWithSocialNetwork:SocialNetworkTypeFacebook Text:self.awardComment.text Image:self.awardImageView.image] animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        [self presentViewController:[[SocialManager sharedManager] shareWithSocialNetwork:SocialNetworkTypeTwitter Text:self.awardComment.text Image:self.awardImageView.image] animated:YES completion:nil];
    }
}

@end
