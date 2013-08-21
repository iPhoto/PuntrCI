//
//  ChangePasswordViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/16/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "PasswordModel.h"
#import "TextField.h"
#import <QuartzCore/QuartzCore.h>

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UIView *viewTextFieldsBackground;

@property (nonatomic, strong) PasswordModel *passwordModel;
@property (nonatomic, strong) TextField *textFieldOldPassword;
@property (nonatomic, strong) TextField *textFieldNewPassword;
@property (nonatomic, strong) TextField *textFieldConfirmPassword;

@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic, strong) UIImageView *imageViewDelimiter;

@property (nonatomic, strong) UIButton *buttonChangePassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passwordModel = [[PasswordModel alloc] init];
	
    self.title = @"Пароль";

    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                           );
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.viewTextFieldsBackground = [[UIView alloc] initWithFrame:CGRectMake(8.0f, 10.0f, 300.0f, 200.0f)];
    self.viewTextFieldsBackground.backgroundColor = [UIColor whiteColor];
    self.viewTextFieldsBackground.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.viewTextFieldsBackground];
    
    self.textFields = [NSArray array];
    
    self.textFieldOldPassword = [[TextField alloc] initWithFrame:CGRectMake(18.0, 19.0f, 282.0f, 38.0f)];
    self.textFieldOldPassword.placeholder = @"Старый пароль...";
    self.textFieldOldPassword.secureTextEntry = YES;
    self.textFieldOldPassword.returnKeyType = UIReturnKeyNext;
    self.textFieldOldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldOldPassword.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldOldPassword];
    [self.view addSubview:self.textFieldOldPassword];
    
    self.textFieldNewPassword = [[TextField alloc] initWithFrame:CGRectMake(18.0, 66.0f, 282.0f, 38.0f)];
    self.textFieldNewPassword.placeholder = @"Новый пароль...";
    self.textFieldNewPassword.secureTextEntry = YES;
    self.textFieldNewPassword.returnKeyType = UIReturnKeyNext;
    self.textFieldNewPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldNewPassword.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldNewPassword];
    [self.view addSubview:self.textFieldNewPassword];

    self.textFieldConfirmPassword = [[TextField alloc] initWithFrame:CGRectMake(18.0f, 113.0f, 282.0f, 38.0f)];
    self.textFieldConfirmPassword.placeholder = @"Подтверждение...";
    self.textFieldConfirmPassword.secureTextEntry = YES;
    self.textFieldConfirmPassword.returnKeyType = UIReturnKeyDone;
    self.textFieldConfirmPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldConfirmPassword.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldConfirmPassword];
    [self.view addSubview:self.textFieldConfirmPassword];
    
    self.viewTextFieldsBackground.frame = CGRectSetHeight(
                                                          self.viewTextFieldsBackground.frame,
                                                          CGRectGetMaxY(self.textFieldConfirmPassword.frame) + 13.0f - CGRectGetMinY(self.viewTextFieldsBackground.frame)
                                                         );
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, viewControllerFrame.size.height - 62.0f, CGRectGetWidth(viewControllerFrame), 2.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"delimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewDelimiter];
    
    self.buttonChangePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonChangePassword.frame = CGRectMake(10.0f, CGRectGetHeight(viewControllerFrame) - 50.0f, 300.0f, 40.0f);
    self.buttonChangePassword.adjustsImageWhenHighlighted = NO;
    [self.buttonChangePassword setTitle:@"Сменить пароль" forState:UIControlStateNormal];
    self.buttonChangePassword.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonChangePassword.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonChangePassword.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonChangePassword addTarget:self action:@selector(changePasswordButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonChangePassword setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonChangePassword];
    
}

- (void)bufferData
{
    self.passwordModel.password = self.textFieldOldPassword.text;
    self.passwordModel.passwordNew = self.textFieldNewPassword.text;
    self.passwordModel.passwordNewConfirmation = self.textFieldConfirmPassword.text;
}

- (BOOL)dataIsValid
{
    if (!self.passwordModel.password || self.passwordModel.password.length == 0)
    {
        [NotificationManager showNotificationMessage:@"Введите пароль"];
        return NO;
    }
    
    if (!self.passwordModel.passwordNew || self.passwordModel.passwordNew.length == 0)
    {
        [NotificationManager showNotificationMessage:@"Введите новый пароль"];
        return NO;
    }
    
    if (!self.passwordModel.passwordNewConfirmation || self.passwordModel.passwordNewConfirmation.length == 0)
    {
        [NotificationManager showNotificationMessage:@"Введите подтверждение нового пароля"];
        return NO;
    }
    
    return YES;
}

- (void)changePassword
{
    [self bufferData];
    if([self dataIsValid])
    {
        [[ObjectManager sharedManager] changePassord:self.passwordModel success:^
            {
                [NotificationManager showSuccessMessage:@"Пароль успешно изменен!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            failure:nil
        ];
    }
}
- (void)changePasswordButtonTouched
{
    [self changePassword];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger index = [self.textFields indexOfObject:textField];
    if (index + 1 < self.textFields.count)
    {
        UITextField *textField = self.textFields[index + 1];
        [textField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self changePassword];
    }
    return YES;
}
@end
