//
//  AwardViewController.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardViewController.h"
#import "SocialManager.h"
#import "UILabel+Puntr.h"

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
    
    self.view.frame = CGRectMake(0.0f, 0.0f, 300.0f, 280.0f);
    self.view.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
//[UIColor colorWithWhite:0.302 alpha:1.000];
    
    NSString *controllerTitle = NSLocalizedString(@"Congratulations! You got a new badge!", nil);
    NSString *awardTitle = self.award.title;
    NSString *awardDescripton = self.award.description;
    
    
    UIFont *titleFont = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
//    CGSize titleSize = [controllerTitle sizeWithFont:titleFont forWidth:CGRectGetWidth(self.view.frame) lineBreakMode:NSLineBreakByWordWrapping];
    self.controllerTitleLabel = [UILabel labelSmallBold:YES black:YES];  
    self.controllerTitleLabel.frame = CGRectMake(coverMargin, coverMargin, self.view.frame.size.width - coverMargin, self.view.frame.size.height);
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
    CGSize awardImageSize = CGSizeMake(imageSide, imageSide);
    [self.awardImageView imageWithUrl:[self.award.image URLByAppendingSize:awardImageSize]];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[self.award.image URLByAppendingSize:awardImageSize]];
//    __weak AwardViewController *weakSelf = self;
//    [self.awardImageView setImageWithURLRequest:urlRequest
//                               placeholderImage:nil
//                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                            if (!weakSelf.award.received)
//                                            {
//                                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                                    UIImage *blurPhotoImage = [PuntrUtilities blurImage:image];
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                        weakSelf.awardImageView.image = blurPhotoImage;
//                                                    });
//                                                });
//                                            }
//                                            else
//                                            {
//                                                weakSelf.awardImageView.image = image;
//                                            }
//                                        }
//                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                                            nil;
//                                        }];
    self.awardImageView.center = CGPointMake(self.view.center.x, (imageSide / 2) + EDGE_VIEWS + CGRectGetMaxY(self.controllerTitleLabel.frame));
    [self.view addSubview:self.awardImageView];
    
    CGFloat labelX = 0.0f;//CGRectGetMaxX(self.awardImageView.frame) + EDGE_VIEWS;
    CGFloat labelWidth = self.view.frame.size.width - labelX;// - EDGE_VIEWS;

    self.awardTitleLabel = [UILabel labelSmallBold:YES black:YES];
    
    CGSize labelSize = [self.award.title sizeWithFont:self.awardTitleLabel.font constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.awardTitleLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.awardImageView.frame) + EDGE_VIEWS, labelWidth, labelSize.height);
    self.awardTitleLabel.backgroundColor = [UIColor clearColor];
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
    
    CGFloat labelY = CGRectGetMaxY(self.awardTitleLabel.frame);

    UIImage *delimiterImage = [[UIImage imageNamed:@"delimiterBlack"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImageView *delimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, labelY + EDGE_VIEWS, self.view.frame.size.width, 2.0f)];
    delimiter.image = delimiterImage;
    delimiter.backgroundColor = [UIColor clearColor];
    [self.view addSubview:delimiter];

    labelY = CGRectGetMaxY(delimiter.frame) + EDGE_VIEWS /2 ;
    
    UIImage *buttonImage = [UIImage imageNamed:@"badge_icon_fb"];
    UIImage *buttonImageHighlighted = [UIImage imageNamed:@"badge_icon_fb_active"];
    
    self.facebookShareAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookShareAwardButton setImage:buttonImage forState:UIControlStateNormal];
    [self.facebookShareAwardButton setImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    
    self.facebookShareAwardButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    self.facebookShareAwardButton.center = CGPointMake(CGRectGetMinX(self.awardImageView.frame) + (buttonImage.size.width / 2), labelY + EDGE_VIEWS + (buttonImage.size.height / 2)); //CGPointMake(CGRectGetMinX(self.awardImageView.frame), labelY + EDGE_VIEWS + (buttonImage.size.height / 2));
    [self.facebookShareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.facebookShareAwardButton];
    
    buttonImage = [UIImage imageNamed:@"badge_icon_tw"];
    buttonImageHighlighted = [UIImage imageNamed:@"badge_icon_tw_active"];

    self.twitterShareAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twitterShareAwardButton setImage:buttonImage forState:UIControlStateNormal];
    [self.twitterShareAwardButton setImage:buttonImageHighlighted forState:UIControlStateHighlighted];

    self.twitterShareAwardButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [self.twitterShareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.twitterShareAwardButton.center = CGPointMake(CGRectGetMaxX(self.awardImageView.frame) - (buttonImage.size.width / 2), labelY + EDGE_VIEWS + (buttonImage.size.height / 2));//CGPointMake(CGRectGetMidX(self.awardImageView.frame), labelY + EDGE_VIEWS + (buttonImage.size.height / 2));
    [self.view addSubview:self.twitterShareAwardButton];
/*
    buttonImage = [UIImage imageNamed:@"badge_icon_vk"];
    buttonImageHighlighted = [UIImage imageNamed:@"badge_icon_vk_active"];
    self.vkShareAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.vkShareAwardButton setImage:buttonImage forState:UIControlStateNormal];
    [self.vkShareAwardButton setImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    self.vkShareAwardButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [self.vkShareAwardButton addTarget:self action:@selector(shareAwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.vkShareAwardButton.center = CGPointMake(CGRectGetMaxX(self.awardImageView.frame), labelY + EDGE_VIEWS + (buttonImage.size.height / 2));
    [self.view addSubview:self.vkShareAwardButton];
*/
}

- (void)shareAwardButtonAction:(UIButton *)button {
    //
    if([button isEqual:self.facebookShareAwardButton])
    {
        [self presentViewController:[[SocialManager sharedManager] shareWithSocialNetwork:SocialNetworkTypeFacebook Text:self.controllerTitleLabel.text Image:self.awardImageView.image] animated:YES completion:nil];
    }
    else if ([button isEqual:self.twitterShareAwardButton])
    {
        [self presentViewController:[[SocialManager sharedManager] shareWithSocialNetwork:SocialNetworkTypeTwitter Text:self.controllerTitleLabel.text Image:self.awardImageView.image] animated:YES completion:nil];
    }
    else if ([button isEqual:self.vkShareAwardButton])
    {
        [[SocialManager sharedManager] shareWithSocialNetwork:SocialNetworkTypeVkontakte Text:self.controllerTitleLabel.text Image:self.awardImageView.image];
    }
}

- (BOOL)becomeFirstResponder {
    return YES;
}

@end
