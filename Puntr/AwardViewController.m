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
@property (nonatomic) BOOL fromPush;

@property (nonatomic, retain) UIImageView *awardImageView;
@property (nonatomic, retain) UILabel *controllerTitleLabel;
@property (nonatomic, retain) UILabel *awardTitleLabel;
@property (nonatomic, retain) UITextField *awardComment;

@property (nonatomic, retain) UIButton *twitterShareAwardButton;
@property (nonatomic, retain) UIButton *facebookShareAwardButton;
@property (nonatomic, retain) UIButton *vkShareAwardButton;

@end

@implementation AwardViewController

- (id)initWithAward:(AwardModel *)award fromPushNotification:(BOOL)fromPush
{
    if (self = [super init])
    {
        _award = award;
        _fromPush = fromPush;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat coverMargin = 8.0f;
    
    self.view.frame = CGRectMake(0.0f, 0.0f, 280.0f, 280.0f);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    NSString *controllerTitle = @"Поздравляем! \nВы получили новый бейдж!";
    NSString *awardTitle = self.award.title;
    NSString *awardDescripton = self.award.description;
    
    
    UIFont *titleFont = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
//    CGSize titleSize = [controllerTitle sizeWithFont:titleFont forWidth:CGRectGetWidth(self.view.frame) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.controllerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(coverMargin, coverMargin, self.view.frame.size.width - coverMargin, self.view.frame.size.height)];
    self.controllerTitleLabel.backgroundColor = [UIColor clearColor];
    self.controllerTitleLabel.font = titleFont;
    self.controllerTitleLabel.textColor = [UIColor whiteColor];
    self.controllerTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.controllerTitleLabel.numberOfLines = 0;
    self.controllerTitleLabel.contentMode = UIViewContentModeCenter;
    self.controllerTitleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.fromPush)
    {
        self.controllerTitleLabel.text = controllerTitle;
    }
    else
    {
        self.controllerTitleLabel.text = awardTitle;
    }
    [self.view addSubview:self.controllerTitleLabel];
    [self.controllerTitleLabel sizeToFit];
    self.controllerTitleLabel.center = CGPointMake(self.view.center.x, self.controllerTitleLabel.center.y);
    
    CGFloat imageSide = 148.0f;
    self.awardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(EDGE_VIEWS, EDGE_VIEWS, imageSide, imageSide)];
    self.awardImageView.backgroundColor = [UIColor clearColor];
    CGSize awardImageSize = CGSizeMake(imageSide, imageSide);
//    [self.awardImageView setImageWithURL:[self.award.image URLByAppendingSize:awardImageSize]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[self.award.image URLByAppendingSize:awardImageSize]];
    __weak AwardViewController *weakSelf = self;
    [self.awardImageView setImageWithURLRequest:urlRequest
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            if (!weakSelf.award.received)
                                            {
                                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                    UIImage *blurPhotoImage = [PuntrUtilities blurImage:image];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        weakSelf.awardImageView.image = blurPhotoImage;
                                                    });
                                                });
                                            }
                                            else
                                            {
                                                weakSelf.awardImageView.image = image;
                                            }
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            nil;
                                        }];
    self.awardImageView.center = CGPointMake(self.view.center.x, (imageSide / 2) + EDGE_VIEWS + CGRectGetMaxY(self.controllerTitleLabel.frame));
    [self.view addSubview:self.awardImageView];
    
    CGFloat labelX = 0.0f;//CGRectGetMaxX(self.awardImageView.frame) + EDGE_VIEWS;
    CGFloat labelWidth = self.view.frame.size.width - labelX;// - EDGE_VIEWS;
    
    CGSize labelSize = [self.award.title sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0f] constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    self.awardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetMaxY(self.awardImageView.frame) + EDGE_VIEWS, labelWidth, labelSize.height)];
    self.awardTitleLabel.backgroundColor = [UIColor clearColor];
    self.awardTitleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    self.awardTitleLabel.textColor = [UIColor whiteColor];
    self.awardTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.awardTitleLabel.contentMode = UIViewContentModeCenter;
    self.awardTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.awardTitleLabel.numberOfLines = 0;
    if (self.fromPush)
    {
        self.awardTitleLabel.text = awardTitle;
    }
    else
    {
        self.awardTitleLabel.text = awardDescripton;
    }
    [self.view addSubview:self.awardTitleLabel];
    [self.awardTitleLabel sizeToFit];
    self.awardTitleLabel.center = CGPointMake(self.view.center.x, self.awardTitleLabel.center.y);
    
    
    labelX += labelWidth / 2;

    UIImage *buttonImage = [UIImage imageNamed:@"icon_fb"];
    UIImage *buttonImageHighlighted = [UIImage imageNamed:@"icon_fb_active"];
    
    self.facebookShareAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookShareAwardButton setImage:buttonImage forState:UIControlStateNormal];
    [self.facebookShareAwardButton setImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    
    self.facebookShareAwardButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    self.facebookShareAwardButton.center = CGPointMake(CGRectGetMinX(self.awardImageView.frame), CGRectGetMaxY(self.awardTitleLabel.frame) + EDGE_VIEWS + (buttonImage.size.height / 2));
    [self.facebookShareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.facebookShareAwardButton];
    
    buttonImage = [UIImage imageNamed:@"icon_tw"];
    buttonImageHighlighted = [UIImage imageNamed:@"icon_tw_active"];

    self.twitterShareAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twitterShareAwardButton setImage:buttonImage forState:UIControlStateNormal];
    [self.twitterShareAwardButton setImage:buttonImageHighlighted forState:UIControlStateHighlighted];

    self.twitterShareAwardButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [self.twitterShareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.twitterShareAwardButton.center = CGPointMake(CGRectGetMidX(self.awardImageView.frame), CGRectGetMaxY(self.awardTitleLabel.frame) + EDGE_VIEWS + (buttonImage.size.height / 2));
    [self.view addSubview:self.twitterShareAwardButton];

    buttonImage = [UIImage imageNamed:@"icon_vk"];
    buttonImageHighlighted = [UIImage imageNamed:@"icon_vk_active"];
    self.vkShareAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.vkShareAwardButton setImage:buttonImage forState:UIControlStateNormal];
    [self.vkShareAwardButton setImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    self.vkShareAwardButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [self.vkShareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.vkShareAwardButton.center = CGPointMake(CGRectGetMaxX(self.awardImageView.frame), CGRectGetMaxY(self.awardTitleLabel.frame) + EDGE_VIEWS + (buttonImage.size.height / 2));
    [self.view addSubview:self.vkShareAwardButton];
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
    [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
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
