//
//  TNIEnterViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIEnterViewController.h"

@interface TNIEnterViewController ()

@property (nonatomic, strong) UITextField *textFieldEmail;
@property (nonatomic, strong) UITextField *textFieldPassword;

@property (nonatomic, copy) NSString *bufferEmail;
@property (nonatomic, copy) NSString *bufferPassword;

@end

@implementation TNIEnterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Вход";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.textFieldEmail = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 130.0, 300.0, 37.0)];
    self.textFieldEmail.placeholder = @"Email или никнейм...";
    self.textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldEmail.returnKeyType = UIReturnKeyNext;
    self.textFieldEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldEmail.delegate = self;
    self.textFieldEmail.backgroundColor = [UIColor colorWithWhite:0.996 alpha:1.000];
    [self.view addSubview:self.textFieldEmail];
    
    self.textFieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 130.0 + 37.0, 300.0, 37.0)];
    self.textFieldPassword.placeholder = @"Пароль...";
    self.textFieldPassword.secureTextEntry = YES;
    self.textFieldPassword.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldPassword.returnKeyType = UIReturnKeySend;
    self.textFieldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldPassword.delegate = self;
    self.textFieldPassword.backgroundColor = [UIColor colorWithWhite:0.996 alpha:1.000];
    [self.view addSubview:self.textFieldPassword];
    
    UIButton *registrationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registrationButton.frame = CGRectMake(13.0, 215.0, 142.0, 40);
    [registrationButton setTitle:@"Регистрация" forState:UIControlStateNormal];
    [registrationButton addTarget:self action:@selector(registrationButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    registrationButton.backgroundColor = [UIColor colorWithWhite:0.282 alpha:1.000];
    [self.view addSubview:registrationButton];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterButton.frame = CGRectMake(13.0 + 142.0 + 9.0, 215.0, 142.0, 40);
    [enterButton setTitle:@"Вход" forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    enterButton.backgroundColor = [UIColor colorWithRed:0.431 green:0.627 blue:0.216 alpha:1.000];
    [self.view addSubview:enterButton];
}

#pragma mark - Actions

- (void)registrationButtonTouched {
    
}

- (void)enterButtonTouched {
    
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
        
    }
}

@end
