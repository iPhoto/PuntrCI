//
//  TNIEnterViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIEnterViewController.h"
#import "TNITabBarViewController.h"
#import "TNIRegistrationViewController.h"
#import "TNIHTTPClient.h"

typedef enum {
    DirectionUp,
    DirectionDown
}Direction;

@interface TNIEnterViewController ()

@property (nonatomic, strong) UITextField *textFieldEmail;
@property (nonatomic, strong) UITextField *textFieldPassword;

@property (nonatomic, strong) UIButton *buttonRegistration;
@property (nonatomic, strong) UIButton *buttonEnter;

@property (nonatomic, copy) NSString *bufferEmail;
@property (nonatomic, copy) NSString *bufferPassword;

@property (nonatomic, strong) UIImageView *imageViewLogoTitle;
@property (nonatomic, strong) UIImageView *imageViewLogoDescription;
@property (nonatomic, strong) UIImageView *imageViewTextFieldsBackground;
@property (nonatomic, strong) UIImageView *imageViewEnterServicies;

@property (nonatomic) BOOL textFildsActive;

@end

@implementation TNIEnterViewController {
    BOOL keyboardIsShown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Вход";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    keyboardIsShown = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    [self.navigationController.navigationBar.subviews[1] setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar.subviews[1] addGestureRecognizer:tap];
    
    // Frame
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f, 0.0f, applicationFrame.size.width, applicationFrame.size.height - self.navigationController.navigationBar.bounds.size.height);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.imageViewLogoTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 42.0f)];
    self.imageViewLogoTitle.image = [UIImage imageNamed:@"logoTitle"];
    [self.view addSubview:self.imageViewLogoTitle];
    
    self.imageViewLogoDescription = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 72.0f, 320.0f, 29.0f)];
    self.imageViewLogoDescription.image = [UIImage imageNamed:@"logoDescription"];
    [self.view addSubview:self.imageViewLogoDescription];
    
    self.imageViewTextFieldsBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 130.0f, 300.0f, 74.0f)];
    self.imageViewTextFieldsBackground.image = [[UIImage imageNamed:@"enterTextFieldsBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(74.0f, 6.0f, 74.0f, 6.0f)];
    [self.view addSubview:self.imageViewTextFieldsBackground];
    
    self.textFieldEmail = [[UITextField alloc] initWithFrame:CGRectMake(21.0, 130.0, 278.0, 35.0)];
    self.textFieldEmail.font = [UIFont fontWithName:@"Arial" size:13.0f];
    self.textFieldEmail.placeholder = @"Email или никнейм...";
    self.textFieldEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldEmail.returnKeyType = UIReturnKeyNext;
    self.textFieldEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldEmail.delegate = self;
    //self.textFieldEmail.backgroundColor = [UIColor colorWithWhite:0.996 alpha:1.000];
    [self.view addSubview:self.textFieldEmail];
    
    self.textFieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(21.0, 130.0 + 38.0, 278.0, 36.0)];
    self.textFieldPassword.font = [UIFont fontWithName:@"Arial" size:13.0f];
    self.textFieldPassword.placeholder = @"Пароль...";
    self.textFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldPassword.secureTextEntry = YES;
    self.textFieldPassword.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldPassword.returnKeyType = UIReturnKeySend;
    self.textFieldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldPassword.delegate = self;
    //self.textFieldPassword.backgroundColor = [UIColor colorWithWhite:0.996 alpha:1.000];
    [self.view addSubview:self.textFieldPassword];
    
    self.buttonRegistration = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonRegistration.frame = CGRectMake(13.0f, 215.0f, 142.0f, 40.0f);
    self.buttonRegistration.adjustsImageWhenHighlighted = NO;
    [self.buttonRegistration setTitle:@"Регистрация" forState:UIControlStateNormal];
    self.buttonRegistration.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonRegistration.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonRegistration.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonRegistration addTarget:self action:@selector(registrationButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonRegistration setBackgroundImage:[[UIImage imageNamed:@"buttonGrey"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0f, 7.0f, 40.0f, 7.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonRegistration];
    
    self.buttonEnter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonEnter.frame = CGRectMake(13.0f + 142.0f + 9.0f, 215.0f, 142.0f, 40.0f);
    self.buttonEnter.adjustsImageWhenHighlighted = NO;
    [self.buttonEnter setTitle:@"Вход" forState:UIControlStateNormal];
    self.buttonEnter.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonEnter.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonEnter.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonEnter setBackgroundImage:[[UIImage imageNamed:@"buttonGreen"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0f, 7.0f, 40.0f, 7.0f)] forState:UIControlStateNormal];
    [self.buttonEnter addTarget:self action:@selector(enterButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonEnter];
    
    self.imageViewEnterServicies = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, viewControllerFrame.size.height - 148.0f, 320.0f, 148.0f)];
    self.imageViewEnterServicies.image = [UIImage imageNamed:@"enterServicies"];
    [self.view addSubview:self.imageViewEnterServicies];
}

#pragma mark - Actions

- (void)registrationButtonTouched {
    [self.navigationController pushViewController:[[TNIRegistrationViewController alloc] initWithEmail:self.bufferEmail] animated:YES];
    [self resignAllResponders];
}

- (void)enterButtonTouched {
    [[TNIHTTPClient sharedClient] testSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldEmail) {
        [textField resignFirstResponder];
        [self.textFieldPassword becomeFirstResponder];
    } else if (textField == self.textFieldPassword) {
        [textField resignFirstResponder];
        [self enter];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.textFieldEmail) {
        self.bufferEmail = textField.text;
    } else if (textField == self.textFieldPassword) {
        self.bufferPassword = textField.text;
    }
    return YES;
}

#pragma mark - Notifications

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] animations:^{
        NSArray *viewsToMove = @[self.textFieldEmail, self.textFieldPassword, self.imageViewTextFieldsBackground, self.buttonEnter, self.buttonRegistration];
        [self moveViews:viewsToMove direction:DirectionDown points:120.0f];
        //[self moveViews:@[<#objects, ...#>] direction:<#(Direction)#> points:<#(CGFloat)#>]
        self.imageViewLogoDescription.alpha = 1.0f;
    }];
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (keyboardIsShown) {
        return;
    }
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] animations:^{
        NSArray *viewsToMove = @[self.textFieldEmail, self.textFieldPassword, self.imageViewTextFieldsBackground, self.buttonEnter, self.buttonRegistration];
        [self moveViews:viewsToMove direction:DirectionUp points:120.0f];
        self.imageViewLogoDescription.alpha = 0.0f;
    }];
    keyboardIsShown = YES;
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

#pragma mark - Logic

- (void)bufferData {
    self.bufferEmail = self.textFieldEmail.text;
    self.bufferPassword = self.textFieldPassword.text;
}

- (BOOL)dataIsValid {
    if (!self.bufferEmail || self.bufferEmail.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите Email или никнейм" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (!self.bufferPassword || self.bufferPassword.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите пароль" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)enter {
    [self bufferData];
    if ([self dataIsValid]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)resignAllResponders {
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
}

- (void)moveViews:(NSArray *)views direction:(Direction)direction points:(CGFloat)points {
    for (UIView *view in views) {
        CGRect viewFrame = view.frame;
        if (direction == DirectionUp) {
            viewFrame.origin.y -= points;
        } else {
            viewFrame.origin.y += points;
        }
        view.frame = viewFrame;
    }
}

@end
