//
//  UpdateProfileViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/19/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "TextField.h"
#import "UserModel.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+AFNetworking.h>

@interface UpdateProfileViewController ()

@property (nonatomic, strong) UIView *viewTextFieldsBackground;

@property (nonatomic, strong) TextField *textFieldFirstName;
@property (nonatomic, strong) TextField *textFieldLastName;
@property (nonatomic, strong) TextField *textFieldUsername;

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) UIImageView *imageViewDelimiter;

@property (nonatomic, strong) UIButton *buttonSaveData;
@property (nonatomic, strong) UIButton *buttonPhoto;

@end

@implementation UpdateProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.user = [[ObjectManager sharedManager] loginedUser];
    
    self.title = @"Профиль";
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds)
                                            );
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.viewTextFieldsBackground = [[UIView alloc] initWithFrame:CGRectMake(8.0f, 10.0f, 300.0f, 200.0f)];
    self.viewTextFieldsBackground.backgroundColor = [UIColor whiteColor];
    self.viewTextFieldsBackground.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.viewTextFieldsBackground];
    
    self.textFieldFirstName = [[TextField alloc] initWithFrame:CGRectMake(112.0, 19.0f, 188.0f, 38.0f)];
    self.textFieldFirstName.placeholder = @"Имя...";
    self.textFieldFirstName.returnKeyType = UIReturnKeyDone;
    self.textFieldFirstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldFirstName.delegate = self;
    [self.view addSubview:self.textFieldFirstName];
    [self.textFieldFirstName setText:self.user.firstName];
    
    self.textFieldLastName = [[TextField alloc] initWithFrame:CGRectMake(112.0, 66.0f, 188.0f, 38.0f)];
    self.textFieldLastName.placeholder = @"Фамилия...";
    self.textFieldLastName.returnKeyType = UIReturnKeyDone;
    self.textFieldLastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldLastName.delegate = self;
    [self.view addSubview:self.textFieldLastName];
    [self.textFieldLastName setText:self.user.lastName];
    
    self.textFieldUsername = [[TextField alloc] initWithFrame:CGRectMake(18.0f, 113.0f, 282.0f, 38.0f)];
    self.textFieldUsername.placeholder = @"Ник...";
    self.textFieldUsername.returnKeyType = UIReturnKeyDone;
    self.textFieldUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldUsername.delegate = self;
    [self.view addSubview:self.textFieldUsername];
    [self.textFieldUsername setText:self.user.username];
    
    self.buttonPhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonPhoto.frame = CGRectMake(18.0f, 19.0f, 85.0f, 85.0f);
    [self.buttonPhoto setBackgroundImage:[UIImage imageNamed:@"reg_avatar"] forState:UIControlStateNormal];
    [self.buttonPhoto setContentMode:UIViewContentModeCenter];
    self.buttonPhoto.tintColor = [UIColor clearColor];
    [self.buttonPhoto.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10.0f]];
    [self.buttonPhoto setTitleColor:[UIColor colorWithRed:0.773 green:0.769 blue:0.769 alpha:1] forState:UIControlStateNormal];
    [self.buttonPhoto.titleLabel setNumberOfLines:0];
    [self.buttonPhoto.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.buttonPhoto setTitleEdgeInsets:UIEdgeInsetsMake(47.0, 0.0, 0, 0.0)];
    [self.buttonPhoto addTarget:self action:@selector(buttonPhotoTouched) forControlEvents:UIControlEventTouchUpInside];
    self.buttonPhoto.layer.cornerRadius = 5;
    self.buttonPhoto.layer.masksToBounds = YES;
    [self.view addSubview:self.buttonPhoto];
    if(!self.user.avatar)
    {
        [self.buttonPhoto setTitle:@"ЗАГРУЗИТЬ\nФОТО" forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonPhoto.imageView setImageWithURL:self.user.avatar];
        [self.buttonPhoto.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    self.viewTextFieldsBackground.frame = CGRectSetHeight(
                                                          self.viewTextFieldsBackground.frame,
                                                          CGRectGetMaxY(self.textFieldUsername.frame) + 13.0f - CGRectGetMinY(self.viewTextFieldsBackground.frame)
                                                          );
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, viewControllerFrame.size.height - 62.0f, CGRectGetWidth(viewControllerFrame), 2.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"delimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewDelimiter];
    
    self.buttonSaveData = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonSaveData.frame = CGRectMake(10.0f, CGRectGetHeight(viewControllerFrame) - 50.0f, 300.0f, 40.0f);
    self.buttonSaveData.adjustsImageWhenHighlighted = NO;
    [self.buttonSaveData setTitle:@"Сохранить" forState:UIControlStateNormal];
    self.buttonSaveData.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonSaveData.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonSaveData.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSaveData addTarget:self action:@selector(saveDataButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSaveData setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSaveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bufferData
{
    self.user.firstName = self.textFieldFirstName.text;
    self.user.lastName = self.textFieldLastName.text;
    self.user.username = self.textFieldUsername.text;
}

- (BOOL)dataIsValid
{
    if (!self.user.firstName || self.user.firstName == 0)
    {
        [NotificationManager showNotificationMessage:@"Введите имя"];
        return NO;
    }
    
    if (!self.user.lastName || self.user.lastName == 0)
    {
        [NotificationManager showNotificationMessage:@"Введите фамилию"];
        return NO;
    }
    
    if (!self.user.username || self.user.username == 0)
    {
        [NotificationManager showNotificationMessage:@"Введите ник"];
        return NO;
    }
    
    return YES;
}


- (void)changePassword
{
    [self bufferData];
    if([self dataIsValid])
    {
        
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
