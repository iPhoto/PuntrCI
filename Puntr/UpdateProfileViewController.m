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
@property (nonatomic, strong) UIImageView *imageViewAvatar;

@property (nonatomic, strong) UIButton *buttonSaveData;
@property (nonatomic, strong) UIButton *buttonPhoto;

@end

@implementation UpdateProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [[ObjectManager sharedManager] loginedUser];
    [self loadProfile];
    
    self.title = NSLocalizedString(@"Profile", nil);
    
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
    
    self.textFieldFirstName = [[TextField alloc] initWithFrame:CGRectMake(112.0, 19.0f, 188.0f, 38.0f)];
    self.textFieldFirstName.placeholder = NSLocalizedString(@"Firstname...", nil);
    self.textFieldFirstName.returnKeyType = UIReturnKeyDone;
    self.textFieldFirstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldFirstName.delegate = self;
    [self.view addSubview:self.textFieldFirstName];
    
    self.textFieldLastName = [[TextField alloc] initWithFrame:CGRectMake(112.0, 66.0f, 188.0f, 38.0f)];
    self.textFieldLastName.placeholder = NSLocalizedString(@"Lastname...", nil);
    self.textFieldLastName.returnKeyType = UIReturnKeyDone;
    self.textFieldLastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldLastName.delegate = self;
    [self.view addSubview:self.textFieldLastName];
    
    self.textFieldUsername = [[TextField alloc] initWithFrame:CGRectMake(18.0f, 113.0f, 282.0f, 38.0f)];
    self.textFieldUsername.placeholder = NSLocalizedString(@"Nickname...", nil);
    self.textFieldUsername.returnKeyType = UIReturnKeyDone;
    self.textFieldUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFieldUsername.delegate = self;
    [self.view addSubview:self.textFieldUsername];
    
    self.imageViewAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(18.0f, 19.0f, 85.0f, 85.0f)];
    self.imageViewAvatar.layer.cornerRadius = 5;
    self.imageViewAvatar.layer.masksToBounds = YES;
    [self.view addSubview: self.imageViewAvatar];
    
    self.buttonPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonPhoto.frame = CGRectMake(18.0f, 19.0f, 85.0f, 85.0f);
    [self.buttonPhoto setBackgroundColor:[UIColor clearColor]];
    //[self.buttonPhoto setBackgroundImage:[UIImage imageNamed:@"reg_avatar"] forState:UIControlStateNormal];
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
    
    
    self.viewTextFieldsBackground.frame = CGRectSetHeight(
                                                          self.viewTextFieldsBackground.frame,
                                                          CGRectGetMaxY(self.textFieldUsername.frame) + 13.0f - CGRectGetMinY(self.viewTextFieldsBackground.frame)
                                                          );
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, viewControllerFrame.size.height - 62.0f, CGRectGetWidth(viewControllerFrame), 2.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"delimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.imageViewDelimiter];
    
    self.buttonSaveData = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonSaveData.frame = CGRectMake(10.0f, CGRectGetHeight(viewControllerFrame) - 50.0f, 300.0f, 40.0f);
    [self.buttonSaveData setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    self.buttonSaveData.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonSaveData.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonSaveData.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSaveData addTarget:self action:@selector(touchedButtonSaveData) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSaveData setBackgroundImage:[[UIImage imageNamed:@"registration"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSaveData];
}

- (void)loadProfile
{
    [[ObjectManager sharedManager] userWithTag:self.user.tag success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         self.user = (UserModel *)mappingResult.firstObject;
         if(!self.user.avatar)
         {
             
             [self.buttonPhoto setBackgroundImage:[UIImage imageNamed:@"reg_avatar"] forState:UIControlStateNormal];
             [self.buttonPhoto setTitle:NSLocalizedString(@"Upload photo", nil) forState:UIControlStateNormal];
         }
         else
         {
             [self.imageViewAvatar setImageWithURL:self.user.avatar];
             [self.imageViewAvatar setImageWithURL:[self.user.avatar URLByAppendingSize:CGSizeMake(85, 85)]];
             [self.imageViewAvatar setContentMode:UIViewContentModeScaleAspectFill];
         }
         [self.textFieldUsername setText:self.user.username];
         [self.textFieldLastName setText:self.user.lastName];
         [self.textFieldFirstName setText:self.user.firstName];
     }
                                       failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [NotificationManager showError:error];
     }
     ];
}
- (void)buttonPhotoTouched{
    UIActionSheet *actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select source", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Gallery", nil), nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    } else {
        [self startCameraControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)touchedButtonSaveData
{
    [self updateProfile];
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
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Enter firstname", nil)];
        return NO;
    }
    
    if (!self.user.lastName || self.user.lastName == 0)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Enter lastname", nil)];
        return NO;
    }
    
    if (!self.user.username || self.user.username == 0)
    {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Enter nickname", nil)];
        return NO;
    }
    
    return YES;
}


- (void)updateProfile
{
    [self bufferData];
    if([self dataIsValid])
    {
        [[ObjectManager sharedManager] updateProfileWithUser:self.user
                                                     success:^
                                                     {
                                                         [NotificationManager showSuccessMessage:NSLocalizedString(@"Profile has been successfully modified!", nil)];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                     failure:nil
         ];
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
    self.imageViewAvatar.hidden = YES;
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
