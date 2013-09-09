//
//  AwardViewController.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardViewController.h"
#import "SocialManager.h"
#import "MZFormSheetController.h"
#import "PushContentViewController.h"

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
    CGFloat imageSide = (self.view.frame.size.width / 2) - (2 *  EDGE_VIEWS);
    
    self.awardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(EDGE_VIEWS, EDGE_VIEWS, imageSide, imageSide)];
    self.awardImageView.backgroundColor = [UIColor clearColor];
    CGSize awardImageSize = CGSizeMake(imageSide, imageSide);
    [self.awardImageView setImageWithURL:[self.award.image URLByAppendingSize:awardImageSize]];
    
    [self.view addSubview:self.awardImageView];
    
    CGFloat labelX = CGRectGetMaxX(self.awardImageView.frame) + EDGE_VIEWS;
    CGFloat labelWidth = self.view.frame.size.width - labelX - EDGE_VIEWS;
    
    CGSize labelSize = [self.award.title sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0f] constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    self.awardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetMidY(self.awardImageView.frame) - (labelSize.height / 2), labelWidth, labelSize.height)];
    self.awardTitleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
    self.awardTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.awardTitleLabel.numberOfLines = 0;
    self.awardTitleLabel.text = self.award.title;

    [self.view addSubview:self.awardTitleLabel];
    
    labelX += labelWidth / 2;
    
    
    self.awardComment = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.awardImageView.frame), CGRectGetMaxY(self.awardImageView.frame) + EDGE_VIEWS, self.view.frame.size.width - (2 * coverMargin), labelSize.height)];
    self.awardComment.placeholder = @"Ваш комментарий";
    self.awardComment.textAlignment = NSTextAlignmentLeft;
    self.awardComment.returnKeyType = UIReturnKeyDone;
    self.awardComment.contentVerticalAlignment  = UIControlContentHorizontalAlignmentCenter;
    self.awardComment.delegate = self;
    [self.view addSubview:self.awardComment];
   
    labelSize = [@"Поделиться" sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.0f] constrainedToSize:CGSizeMake(self.view.frame.size.width - (2 * coverMargin) - CGRectGetMinX(self.awardImageView.frame), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    self.shareAwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareAwardButton.frame = CGRectMake(CGRectGetMinX(self.awardImageView.frame), CGRectGetMaxY(self.awardComment.frame) + EDGE_VIEWS, self.view.frame.size.width - (2 * coverMargin) - CGRectGetMinX(self.awardImageView.frame), 2 * labelSize.height);
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
    [sheet addButtonWithTitle:@"Push test"];
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
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
    else if (buttonIndex == 2)
    {
        PushContentViewController *vc = [[PushContentViewController alloc] init];
        // present form sheet with view controller
        [self presentFormSheetWithViewController:vc animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        }];
    }
}

@end
