//
//  TNIRegistrationViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIRegistrationViewController.h"

@interface TNIRegistrationViewController ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UITextField *textFieldNickname;
@property (nonatomic, strong) UITextField *textFieldLastName;
@property (nonatomic, strong) UITextField *textFieldFirstName;
@property (nonatomic, strong) UITextField *textFieldPassword;
@property (nonatomic, strong) UITextField *textFieldEmail;

@property (nonatomic, copy) NSString *bufferEmail;

@end

@implementation TNIRegistrationViewController

- (id)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self) {
        _bufferEmail = email;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Регистрация";
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.textFieldEmail = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 130.0, 300.0, 37.0)];
    self.textFieldEmail.placeholder = @"Email или никнейм...";
    self.textFieldEmail.text = self.bufferEmail;
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
    
    
}

@end
