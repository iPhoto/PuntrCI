//
//  RegistrationViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RegistrationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TextField.h"
#import "ObjectManager.h"
#import "UserModel.h"
#import "TabBarViewController.h"
#import "NotificationManager.h"

@interface RegistrationViewController ()

@property (nonatomic, strong) UIView *viewTextFieldsBackground;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TextField *textFieldUsername;
@property (nonatomic, strong) TextField *textFieldLastName;
@property (nonatomic, strong) TextField *textFieldFirstName;
@property (nonatomic, strong) TextField *textFieldPassword;
@property (nonatomic, strong) TextField *textFieldEmail;

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) UIImageView *imageViewDelimiter;

@property (nonatomic, strong) UIButton *buttonRegistration;
@property (nonatomic, strong) UIButton *buttonPhoto;

@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic) BOOL animating;

@property (nonatomic) BOOL keyboardIsShown;

@end

@implementation RegistrationViewController

- (id)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self)
    {
        _user = [[UserModel alloc] init];
        _user.email = email;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Регистрация";
    
    // Frame
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds)
                                            );
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
    
    self.textFieldEmail = [[TextField alloc] initWithFrame:CGRectMake(18.0f, 113.0f, 282.0f, 38.0f)];//(18.0f, 19.0f, 282.0f, 38.0f)
    self.textFieldEmail.placeholder = @"Email...";
    self.textFieldEmail.text = self.user.email;
    self.textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldEmail.returnKeyType = UIReturnKeyNext;
    self.textFieldEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldEmail.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldEmail];
    [self.scrollView addSubview:self.textFieldEmail];
    
    self.textFieldPassword = [[TextField alloc] initWithFrame:CGRectMake(18.0, 160.0f, 282.0f, 38.0f)];//(18.0, 66.0f, 282.0f, 38.0f)
    self.textFieldPassword.placeholder = @"Пароль...";
    self.textFieldPassword.secureTextEntry = YES;
    self.textFieldPassword.keyboardType = UIKeyboardTypeDefault;
    self.textFieldPassword.returnKeyType = UIReturnKeyNext;
    self.textFieldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldPassword.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldPassword];
    [self.scrollView addSubview:self.textFieldPassword];
    
    self.textFieldUsername = [[TextField alloc] initWithFrame:CGRectMake(18.0, 207.0f, 282.0f, 38.0f)];//(18.0, 113.0f, 282.0f, 38.0f)
    self.textFieldUsername.placeholder = @"Никнейм...";
    self.textFieldUsername.returnKeyType = UIReturnKeyNext;
    self.textFieldUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldUsername.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldUsername];
    [self.scrollView addSubview:self.textFieldUsername];
    
    self.textFieldFirstName = [[TextField alloc] initWithFrame:CGRectMake(112.0, 19.0f, 188.0f, 38.0f)];//(18.0, 160.0f, 282.0f, 38.0f)
    self.textFieldFirstName.placeholder = @"Имя...";
    self.textFieldFirstName.returnKeyType = UIReturnKeyNext;
    self.textFieldFirstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textFieldFirstName.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldFirstName];
    [self.scrollView addSubview:self.textFieldFirstName];
    
    self.textFieldLastName = [[TextField alloc] initWithFrame:CGRectMake(112.0, 66.0f, 188.0f, 38.0f)];//(18.0, 207.0f, 282.0f, 38.0f)
    self.textFieldLastName.placeholder = @"Фамилия...";
    self.textFieldLastName.returnKeyType = UIReturnKeyDone;
    self.textFieldLastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textFieldLastName.delegate = self;
    self.textFields = [self.textFields arrayByAddingObject:self.textFieldLastName];
    [self.scrollView addSubview:self.textFieldLastName];
    
    self.buttonPhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonPhoto.frame = CGRectMake(18.0f, 19.0f, 85.0f, 85.0f);
    [self.buttonPhoto setBackgroundImage:[UIImage imageNamed:@"reg_avatar"] forState:UIControlStateNormal];
    [self.buttonPhoto setContentMode:UIViewContentModeCenter];
    self.buttonPhoto.tintColor = [UIColor clearColor];
    [self.buttonPhoto.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10.0f]];
    [self.buttonPhoto setTitleColor:[UIColor colorWithRed:0.773 green:0.769 blue:0.769 alpha:1] forState:UIControlStateNormal];
    [self.buttonPhoto.titleLabel setNumberOfLines:0];
    [self.buttonPhoto.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.buttonPhoto setTitle:@"ЗАГРУЗИТЬ\nФОТО" forState:UIControlStateNormal];
    [self.buttonPhoto setTitleEdgeInsets:UIEdgeInsetsMake(47.0, 0.0, 0, 0.0)];
    [self.buttonPhoto addTarget:self action:@selector(buttonPhotoTouched) forControlEvents:UIControlEventTouchUpInside];
    self.buttonPhoto.layer.cornerRadius = 5;
    self.buttonPhoto.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.buttonPhoto];
    
    self.viewTextFieldsBackground.frame = CGRectSetHeight(
                                                          self.viewTextFieldsBackground.frame,
                                                          CGRectGetMaxY(self.textFieldUsername.frame) + 13.0f - CGRectGetMinY(self.viewTextFieldsBackground.frame)
                                                          );
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, viewControllerFrame.size.height - 62.0f, CGRectGetWidth(viewControllerFrame), 2.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"delimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.scrollView addSubview:self.imageViewDelimiter];
    
    self.buttonRegistration = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonRegistration.frame = CGRectMake(10.0f, CGRectGetHeight(viewControllerFrame) - 50.0f, 300.0f, 40.0f);
    self.buttonRegistration.adjustsImageWhenHighlighted = NO;
    [self.buttonRegistration setTitle:@"Регистрация" forState:UIControlStateNormal];
    self.buttonRegistration.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonRegistration.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonRegistration.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonRegistration addTarget:self action:@selector(registrationButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonRegistration setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.buttonRegistration];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger index = [self.textFields indexOfObject:textField];
    if (index + 1 < self.textFields.count)
    {
        UITextField *textField = self.textFields[index + 1];
        [textField becomeFirstResponder];
        [self.scrollView scrollRectToVisible:textField.frame animated:YES];
    }
    else
    {
        if (!self.animating)
        {
            [self resignAllResponders];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.textFieldEmail)
    {
        self.user.email = self.textFieldEmail.text;
    }
    else if (textField == self.textFieldPassword)
    {
        self.user.password = self.textFieldPassword.text;
    }
    else if (textField == self.textFieldUsername)
    {
        self.user.username = self.textFieldUsername.text;
    }
    else if (textField == self.textFieldFirstName)
    {
        self.user.firstName = self.textFieldFirstName.text;
    }
    else if (textField == self.textFieldLastName)
    {
        self.user.lastName = self.textFieldLastName.text;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.keyboardIsShown)
    {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    
    viewFrame = CGRectResize(viewFrame, 0.0f, -keyboardSize.height);
    
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] animations:^
        {
            [self.scrollView setFrame:viewFrame];
            self.animating = YES;
        }
        completion:^(BOOL finished)
        {
            self.animating = NO;
        }
    ];
    self.keyboardIsShown = YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    TextField *textField = [self firstResponderTextField];
    if (textField)
    {
        [self.scrollView scrollRectToVisible:textField.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.keyboardIsShown)
    {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    
    viewFrame = CGRectResize(viewFrame, 0.0f, keyboardSize.height);
    
    [UIView animateWithDuration:0.3f animations:^
        {
            [self.scrollView setFrame:viewFrame];
            self.animating = YES;
        }
        completion:^(BOOL finished)
        {
            self.animating = NO;
        }
    ];
    
    self.keyboardIsShown = NO;
}

- (void)bufferData
{
    self.user.email = self.textFieldEmail.text;
    self.user.password = self.textFieldPassword.text;
    self.user.username = self.textFieldUsername.text;
    self.user.firstName = self.textFieldFirstName.text;
    self.user.lastName = self.textFieldLastName.text;
}

- (BOOL)dataIsValid
{
    if (!self.user.email || self.user.email.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите Email" message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (!self.user.password || self.user.password.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите пароль" message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (!self.user.username || self.user.username.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите никнейм" message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (!self.user.firstName || self.user.firstName.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите имя" message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (!self.user.lastName || self.user.lastName.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Введите фамилию" message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)registrationButtonTouched
{
    [self registration];
}

- (void)registration
{
    [self bufferData];
    if ([self dataIsValid])
    {
        [[ObjectManager sharedManager] registerWithUser:self.user success:^(AuthorizationModel *authorization, UserModel *user)
            {
                TabBarViewController *tabBar = [[TabBarViewController alloc] init];
                [UIView transitionWithView:[[UIApplication sharedApplication] keyWindow]
                                  duration:0.3f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^
                                {
                                    [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBar];
                                }
                                completion:nil
                ];
            }
            failure:nil
        ];
    }
}

- (void)buttonPhotoTouched{
    UIActionSheet *actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Выберите источник" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Камера", @"Галерея", nil];
        [actionSheet showInView:self.view];
    } else {
        [self startCameraControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

- (TextField *)firstResponderTextField
{
    for (TextField *textField in self.textFields)
    {
        if ([textField isFirstResponder])
        {
            return textField;
        }
    }
    return nil;
}

- (void)resignAllResponders
{
    for (TextField *textField in self.textFields)
    {
        [textField resignFirstResponder];
    }
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self startCameraControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [self startCameraControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}

- (void)startCameraControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = sourceType;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage, *editedImage, *imageToSave;
    editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    self.user.avatarData = imageToSave;
    [self.buttonPhoto setImage:imageToSave forState:UIControlStateNormal];
    [self.buttonPhoto.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.buttonPhoto setTitle:@"" forState:UIControlStateNormal];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
