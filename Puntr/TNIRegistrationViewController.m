//
//  TNIRegistrationViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIRegistrationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TNITextField.h"
#import "TNIHTTPClient.h"

@interface TNIRegistrationViewController ()

@property (nonatomic, strong) UIView *viewTextFieldsBackground;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) TNITextField *textFieldUsername;
@property (nonatomic, strong) NSString *bufferUsername;
@property (nonatomic, strong) TNITextField *textFieldLastName;
@property (nonatomic, strong) NSString *bufferLastName;
@property (nonatomic, strong) TNITextField *textFieldFirstName;
@property (nonatomic, strong) NSString *bufferFirstName;
@property (nonatomic, strong) TNITextField *textFieldPassword;
@property (nonatomic, strong) NSString *bufferPassword;
@property (nonatomic, strong) TNITextField *textFieldEmail;
@property (nonatomic, strong) NSString *bufferEmail;

@property (nonatomic, strong) UIImageView *imageViewDelimiter;

@property (nonatomic, strong) UIButton *buttonRegistration;

@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic) BOOL animating;

@end

@implementation TNIRegistrationViewController {
    BOOL keyboardIsShown;
}

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
    // Frame
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f, 0.0f, applicationFrame.size.width, applicationFrame.size.height - self.navigationController.navigationBar.bounds.size.height);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:viewControllerFrame];
    self.scrollView.contentSize = viewControllerFrame.size;
    [self.view addSubview:self.scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
    
    self.viewTextFieldsBackground = [[UIView alloc] initWithFrame:CGRectMake(8.0f, 10.0f, 300.0f, 200.0f)];
    self.viewTextFieldsBackground.backgroundColor = [UIColor whiteColor];
    self.viewTextFieldsBackground.layer.cornerRadius = 5.0f;
    [self.scrollView addSubview:self.viewTextFieldsBackground];
    
    self.textFields = [NSArray array];
    
    self.textFieldEmail = [[TNITextField alloc] initWithFrame:CGRectMake(18.0f, 19.0f, 282.0f, 38.0f)];
    self.textFieldEmail.placeholder = @"Email...";
    self.textFieldEmail.text = self.bufferEmail;
    self.textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldEmail.returnKeyType = UIReturnKeyNext;
    self.textFieldEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldEmail.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldEmail];
    [self.scrollView addSubview:self.textFieldEmail];
    
    self.textFieldPassword = [[TNITextField alloc] initWithFrame:CGRectMake(18.0, 66.0f, 282.0f, 38.0f)];
    self.textFieldPassword.placeholder = @"Пароль...";
    self.textFieldPassword.secureTextEntry = YES;
    self.textFieldPassword.keyboardType = UIKeyboardTypeDefault;
    self.textFieldPassword.returnKeyType = UIReturnKeyNext;
    self.textFieldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldPassword.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldPassword];
    [self.scrollView addSubview:self.textFieldPassword];
    
    self.textFieldUsername = [[TNITextField alloc] initWithFrame:CGRectMake(18.0, 113.0f, 282.0f, 38.0f)];
    self.textFieldUsername.placeholder = @"Никнейм...";
    self.textFieldUsername.returnKeyType = UIReturnKeyNext;
    self.textFieldUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldUsername.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldUsername];
    [self.scrollView addSubview:self.textFieldUsername];
    
    self.textFieldFirstName = [[TNITextField alloc] initWithFrame:CGRectMake(18.0, 160.0f, 282.0f, 38.0f)];
    self.textFieldFirstName.placeholder = @"Имя...";
    self.textFieldFirstName.returnKeyType = UIReturnKeyNext;
    self.textFieldFirstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textFieldFirstName.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldFirstName];
    [self.scrollView addSubview:self.textFieldFirstName];
    
    self.textFieldLastName = [[TNITextField alloc] initWithFrame:CGRectMake(18.0, 207.0f, 282.0f, 38.0f)];
    self.textFieldLastName.placeholder = @"Фамилия...";
    self.textFieldLastName.returnKeyType = UIReturnKeyDone;
    self.textFieldLastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textFieldLastName.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldLastName];
    [self.scrollView addSubview:self.textFieldLastName];
    
    CGRect textFieldsBackgroundFrame = self.viewTextFieldsBackground.frame;
    textFieldsBackgroundFrame.size.height = self.textFieldLastName.frame.origin.y + self.textFieldLastName.frame.size.height + 13.0f - textFieldsBackgroundFrame.origin.y;
    self.viewTextFieldsBackground.frame = textFieldsBackgroundFrame;
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, viewControllerFrame.size.height - 62.0f, viewControllerFrame.size.width, 2.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"delimiter"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 2.0f, 0.0f)];
    [self.scrollView addSubview:self.imageViewDelimiter];
    
    self.buttonRegistration = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonRegistration.frame = CGRectMake(10.0f, viewControllerFrame.size.height - 50.0f, 300.0f, 40.0f);
    self.buttonRegistration.adjustsImageWhenHighlighted = NO;
    [self.buttonRegistration setTitle:@"Регистрация" forState:UIControlStateNormal];
    self.buttonRegistration.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonRegistration.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonRegistration.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonRegistration addTarget:self action:@selector(registrationButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonRegistration setBackgroundImage:[[UIImage imageNamed:@"buttonGrey"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0f, 7.0f, 40.0f, 7.0f)] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.buttonRegistration];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUInteger index = [self.textFields indexOfObject:textField];
    if (index + 1 < self.textFields.count) {
        [self.textFields[index + 1] becomeFirstResponder];
    } else {
        if (!self.animating) {
            [self resignAllResponders];
        } else {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.textFieldEmail) {
        self.bufferEmail = self.textFieldEmail.text;
    } else if (textField == self.textFieldPassword) {
        self.bufferPassword = self.textFieldPassword.text;
    } else if (textField == self.textFieldUsername) {
        self.bufferUsername = self.textFieldUsername.text;
    } else if (textField == self.textFieldFirstName) {
        self.bufferFirstName = self.textFieldFirstName.text;
    } else if (textField == self.textFieldLastName) {
        self.bufferLastName = self.textFieldLastName.text;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (keyboardIsShown) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    
    viewFrame.size.height -= (keyboardSize.height);
    
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] animations:^{
        [self.scrollView setFrame:viewFrame];
        self.animating = YES;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
    keyboardIsShown = YES;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    TNITextField *textField = [self firstResponderTextField];
    if (textField) {
        [self.scrollView scrollRectToVisible:textField.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    
    viewFrame.size.height += (keyboardSize.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setFrame:viewFrame];
        self.animating = YES;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
    
    keyboardIsShown = NO;
}

- (void)bufferData {
    self.bufferEmail = self.textFieldEmail.text;
    self.bufferPassword = self.textFieldPassword.text;
    self.bufferUsername = self.textFieldUsername.text;
    self.bufferFirstName = self.textFieldFirstName.text;
    self.bufferLastName = self.textFieldLastName.text;
}

- (BOOL)dataIsValid {
    if (!self.bufferEmail || self.bufferEmail.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите Email" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (!self.bufferPassword || self.bufferPassword.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите пароль" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (!self.bufferUsername || self.bufferUsername.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите никнейм" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (!self.bufferFirstName || self.bufferFirstName.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите имя" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (!self.bufferLastName || self.bufferLastName.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите фамилию" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)registrationButtonTouched {
    [self registration];
}

- (void)registration {
    [self bufferData];
    if ([self dataIsValid]) {
        [[TNIHTTPClient sharedClient] registerWithEmail:self.bufferEmail password:self.bufferPassword firstname:self.bufferFirstName lastname:self.bufferLastName username:self.bufferUsername success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

- (TNITextField *)firstResponderTextField {
    for (TNITextField *textField in self.textFields) {
        if ([textField isFirstResponder]) {
            return textField;
        }
    }
    return nil;
}

- (void)resignAllResponders {
    for (TNITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
}

@end
