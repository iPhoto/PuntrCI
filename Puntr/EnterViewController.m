//
//  EnterViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AuthorizationModel.h"
#import "CredentialsModel.h"
#import "DefaultsManager.h"
#import "EnterViewController.h"
#import "HTTPClient.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "RegistrationViewController.h"
#import "SocialManager.h"
#import "TabBarViewController.h"
#import "UserModel.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <SVProgressHUD/SVProgressHUD.h>

typedef NS_ENUM(NSInteger, Direction)
{
    DirectionUp,
    DirectionDown
};

@interface EnterViewController ()

@property (nonatomic, strong) UITextField *textFieldLogin;
@property (nonatomic, strong) UITextField *textFieldPassword;

@property (nonatomic, strong) UIButton *buttonRegistration;
@property (nonatomic, strong) UIButton *buttonEnter;
@property (nonatomic, strong) UIButton *buttonFb;
@property (nonatomic, strong) UIButton *buttonTw;
@property (nonatomic, strong) UIButton *buttonVk;

@property (nonatomic, strong) CredentialsModel *credentials;

@property (nonatomic, strong) UIImageView *imageViewLogoTitle;
@property (nonatomic, strong) UIImageView *imageViewLogoDescription;
@property (nonatomic, strong) UIImageView *imageViewTextFieldsBackground;
@property (nonatomic, strong) UIImageView *imageViewEnterServicies;

@property (nonatomic) BOOL textFildsActive;

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, retain) ACAccount *twitterAccount;

@property (nonatomic) BOOL keyboardIsShown;

@end

@implementation EnterViewController

+ (EnterViewController *)enter
{
    return [[self alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Enter", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(close)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    self.keyboardIsShown = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    
    [self.navigationController.navigationBar.subviews[1] setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar.subviews[1] addGestureRecognizer:tap];
    
    // Frame
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds)
                                            );
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.credentials = [[CredentialsModel alloc] init];
    
    self.imageViewLogoTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 42.0f)];
    self.imageViewLogoTitle.image = [UIImage imageNamed:@"logo-puntr"];
    self.imageViewLogoTitle.userInteractionEnabled = YES;
    [self.imageViewLogoTitle addGestureRecognizer:tap];
    [self.view addSubview:self.imageViewLogoTitle];
    
    self.imageViewLogoDescription = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 72.0f, 320.0f, 29.0f)];
    self.imageViewLogoDescription.image = [UIImage imageNamed:@"logoDescription"];
    [self.view addSubview:self.imageViewLogoDescription];
    
    self.imageViewTextFieldsBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 130.0f, 300.0f, 74.0f)];
    self.imageViewTextFieldsBackground.image = [[UIImage imageNamed:@"enterTextFieldsBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
    [self.view addSubview:self.imageViewTextFieldsBackground];
    
    self.textFieldLogin = [[UITextField alloc] initWithFrame:CGRectMake(21.0, 130.0, 278.0, 35.0)];
    self.textFieldLogin.font = [UIFont fontWithName:@"ArialMT" size:13.0f];
    self.textFieldLogin.placeholder = NSLocalizedString(@"Email or nickname...", nil);
    self.textFieldLogin.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldLogin.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldLogin.returnKeyType = UIReturnKeyNext;
    self.textFieldLogin.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldLogin.delegate = self;
    [self.textFieldLogin setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:self.textFieldLogin];
    //self.textFieldLogin.text = @"qqq@gmail.com";
    
    self.textFieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(21.0, 130.0 + 38.0, 278.0, 36.0)];
    self.textFieldPassword.font = [UIFont fontWithName:@"ArialMT" size:13.0f];
    self.textFieldPassword.placeholder = NSLocalizedString(@"Password...", nil);
    self.textFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldPassword.secureTextEntry = YES;
    self.textFieldPassword.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldPassword.returnKeyType = UIReturnKeySend;
    self.textFieldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldPassword.delegate = self;
    [self.textFieldPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:self.textFieldPassword];
    //self.textFieldPassword.text = @"qqqqqq";
    
    self.buttonRegistration = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonRegistration.frame = CGRectMake(13.0f, 215.0f, 142.0f, 40.0f);
    [self.buttonRegistration setTitle:NSLocalizedString(@"Registration", nil) forState:UIControlStateNormal];
    self.buttonRegistration.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonRegistration.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonRegistration.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonRegistration addTarget:self action:@selector(registrationButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonRegistration setBackgroundImage:[[UIImage imageNamed:@"registration"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonRegistration];
    
    self.buttonEnter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonEnter.frame = CGRectMake(13.0f + 142.0f + 9.0f, 215.0f, 142.0f, 40.0f);
    [self.buttonEnter setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    self.buttonEnter.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonEnter.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonEnter.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonEnter setBackgroundImage:[[UIImage imageNamed:@"login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.buttonEnter addTarget:self action:@selector(enterButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonEnter];
    
    self.imageViewEnterServicies = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(viewControllerFrame) - 148.0f, 320.0f, 148.0f)];
    self.imageViewEnterServicies.image = [UIImage imageNamed:@"enterServicies"];
    [self.view addSubview:self.imageViewEnterServicies];
    
    self.buttonFb = [[UIButton alloc]initWithFrame:CGRectMake(
                                                              10.0f,
                                                              CGRectGetMinY(self.imageViewEnterServicies.frame) + 52.0f,
                                                              300.0f,
                                                              42.0f
                                                              )];
    [self.buttonFb setBackgroundColor:[UIColor clearColor]];
    [self.buttonFb setBackgroundImage:[UIImage imageNamed:@"middle"] forState:UIControlStateNormal];
    [self.buttonFb setBackgroundImage:[UIImage imageNamed:@"middle_active"] forState:UIControlStateHighlighted];
    [self.buttonFb setImage:[UIImage imageNamed:@"icon_fb"] forState:UIControlStateNormal];
    [self.buttonFb setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 255)];
    [self.buttonFb setTitle:NSLocalizedString(@"Login with Facebook", nil) forState:UIControlStateNormal];
    self.buttonFb.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonFb.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonFb.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.buttonFb.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.buttonFb setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 86)];
    [self.buttonFb addTarget:self action:@selector(fbButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonFb];
    CGSize fbTextSize = [self.buttonFb.titleLabel.text sizeWithFont:self.buttonFb.titleLabel.font];
    
    self.buttonTw = [[UIButton alloc]initWithFrame:CGRectMake(
                                                              10.0f,
                                                              CGRectGetMinY(self.imageViewEnterServicies.frame) + 94.0f,
                                                              300.0f,
                                                              42.0f
                                                              )];
    [self.buttonTw setBackgroundColor:[UIColor clearColor]];
    [self.buttonTw setBackgroundImage:[UIImage imageNamed:@"bottom"] forState:UIControlStateNormal];
    [self.buttonTw setBackgroundImage:[UIImage imageNamed:@"bottom_active"] forState:UIControlStateHighlighted];
    [self.buttonTw setImage:[UIImage imageNamed:@"icon_tw"] forState:UIControlStateNormal];
    [self.buttonTw setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 255)];
    [self.buttonTw setTitle:NSLocalizedString(@"Login with Twitter", nil) forState:UIControlStateNormal];
    self.buttonTw.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonTw.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonTw.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.buttonTw.titleLabel.textAlignment = NSTextAlignmentLeft;
    CGSize twTextSize = [self.buttonTw.titleLabel.text sizeWithFont:self.buttonTw.titleLabel.font];
    [self.buttonTw setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 86 + fbTextSize.width - twTextSize.width)];
    [self.buttonTw addTarget:self action:@selector(twButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonTw];
    
    self.buttonVk = [[UIButton alloc]initWithFrame:CGRectMake(
                                                              10.0f,
                                                              CGRectGetMinY(self.imageViewEnterServicies.frame) + 10.0f,
                                                              300.0f,
                                                              42.0f
                                                              )];
    [self.buttonVk setBackgroundColor:[UIColor clearColor]];
    [self.buttonVk setBackgroundImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    [self.buttonVk setBackgroundImage:[UIImage imageNamed:@"top_active"] forState:UIControlStateHighlighted];
    [self.buttonVk setImage:[UIImage imageNamed:@"icon_vk"] forState:UIControlStateNormal];
    [self.buttonVk setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 255)];
    [self.buttonVk setTitle:NSLocalizedString(@"Login with VKontakte", nil) forState:UIControlStateNormal];
    self.buttonVk.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonVk.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonVk.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    self.buttonVk.titleLabel.textAlignment = NSTextAlignmentLeft;
    CGSize vkTextSize = [self.buttonVk.titleLabel.text sizeWithFont:self.buttonVk.titleLabel.font];
    [self.buttonVk setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 86 + fbTextSize.width - vkTextSize.width)];
    [self.buttonVk addTarget:self action:@selector(vkButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonVk];
}

- (void)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)registrationButtonTouched
{
    [self.navigationController pushViewController:[[RegistrationViewController alloc] initWithEmail:self.textFieldLogin.text] animated:YES];
    [self resignAllResponders];
}

- (void)enterButtonTouched
{
    [self login];
}

- (void)fbButtonTouched
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[SocialManager sharedManager] loginWithSocialNetworkOfType:SocialNetworkTypeFacebook
                                                        success:^(AccessModel *accessModel)
                                                        {
                                                            [self loginWithSocialModel:accessModel];
                                                        }
                                                        failure:^(NSError *error)
                                                        {
                                                            if (error)
                                                            {
                                                                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                            }
                                                            else
                                                            {
                                                                [SVProgressHUD dismiss];
                                                            }
                                                        }
     ];
}

- (void)twButtonTouched
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [SocialManager sharedManager].delegate = self;
    [[SocialManager sharedManager] loginWithSocialNetworkOfType:SocialNetworkTypeTwitter
                                                        success:^(AccessModel *accessModel)
                                                        {
                                                            //[SVProgressHUD dismiss];
                                                            [self loginWithSocialModel:accessModel];
                                                        }
                                                        failure:^(NSError *error)
                                                        {
                                                            if (error)
                                                            {
                                                                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                            }
                                                            else
                                                            {
                                                                [SVProgressHUD dismiss];
                                                            }
                                                        }
     ];
}

- (void)vkButtonTouched
{
    [[SocialManager sharedManager] loginWithSocialNetworkOfType:SocialNetworkTypeVkontakte
                                                        success:^(AccessModel *accessModel)
                                                        {
                                                            [self loginWithSocialModel:accessModel];
                                                        }
                                                        failure:nil
    ];
}

- (void)socialManager:(SocialManager *)sender twitterAccounts:(NSArray *)array
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choose an Account", nil)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for (NSString *name in array)
    {
        [sheet addButtonWithTitle:name];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [sheet showInView:self.view];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textFieldLogin)
    {
        [self.textFieldPassword becomeFirstResponder];
    }
    else if (textField == self.textFieldPassword)
    {
        [textField resignFirstResponder];
        [self login];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.textFieldLogin)
    {
        self.credentials.login = textField.text;
    }
    else if (textField == self.textFieldPassword)
    {
        self.credentials.password = textField.text;
    }
    return YES;
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (![[[touch view] class] isSubclassOfClass:[UIControl class]]);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [[SocialManager sharedManager] loginTwWithUser:buttonIndex];
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    [SVProgressHUD dismiss];
}

#pragma mark - Notifications

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] animations:^{
        NSArray *viewsToMove = @[self.textFieldLogin, self.textFieldPassword, self.imageViewTextFieldsBackground, self.buttonEnter, self.buttonRegistration];
        [self moveViews:viewsToMove direction:DirectionDown points:65.0f];
        [self moveViews:@[self.imageViewLogoTitle] direction:DirectionDown points:20.0f];
        self.imageViewLogoDescription.alpha = 1.0f;
    }];
    self.keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.keyboardIsShown)
    {
        return;
    }
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] animations:^{
        NSArray *viewsToMove = @[self.textFieldLogin, self.textFieldPassword, self.imageViewTextFieldsBackground, self.buttonEnter, self.buttonRegistration];
        [self moveViews:viewsToMove direction:DirectionUp points:65.0f];
        [self moveViews:@[self.imageViewLogoTitle] direction:DirectionUp points:20.0f];
        self.imageViewLogoDescription.alpha = 0.0f;
    }];
    self.keyboardIsShown = YES;
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

#pragma mark - Logic

- (void)bufferData
{
    self.credentials.login = self.textFieldLogin.text;
    self.credentials.password = self.textFieldPassword.text;
}

- (BOOL)dataIsValid
{
    if (!self.credentials.login || self.credentials.login.length == 0)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Enter Email or nickname", nil)];
        return NO;
    }
    if (!self.credentials.password || self.credentials.password.length == 0)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Enter password", nil)];
        return NO;
    }
    return YES;
}

- (void)login
{
    [self bufferData];
    if ([self dataIsValid])
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[ObjectManager sharedManager] logInWithAccess:self.credentials success:^(AuthorizationModel *authorization, UserModel *user)
            {
                [self transitionToTabBar];
            }
            failure:^
            {
                [SVProgressHUD dismiss];
            }
        ];
    }
}

- (void)loginWithSocialModel:(AccessModel *)socialModel
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[ObjectManager sharedManager] logInWithAccess:socialModel
                                           success:^(AuthorizationModel *authorization, UserModel *user)
                                           {
                                               [self transitionToTabBar];
                                           }
                                           failure:^
                                           {
                                               [SVProgressHUD dismiss];
                                           }
    ];
}

- (void)resignAllResponders
{
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldLogin resignFirstResponder];
}

- (void)moveViews:(NSArray *)views direction:(Direction)direction points:(CGFloat)points
{
    for (UIView *view in views)
    {
        if (direction == DirectionUp)
        {
            view.frame = CGRectOffset(view.frame, 0.0f, -points);
        }
        else
        {
            view.frame = CGRectOffset(view.frame, 0.0f, points);
        }
    }
}

- (void)transitionToTabBar
{
    [SVProgressHUD dismiss];
    [self close];
}

@end
