//
//  PrivacySettingsViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/21/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PrivacySettingsViewController.h"
#import "CollectionManager.h"

@interface PrivacySettingsViewController ()

@property ()DynamicSelction dynamicSelection;
@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation PrivacySettingsViewController

- (id)initWithDynamicSelection:(DynamicSelction) dynamicSelection
{
    self = [super init];
    if (self) {
        _dynamicSelection = dynamicSelection;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
    switch (self.dynamicSelection)
    {
        case DynamicSelctionPrivacy:
        {
            self.title = NSLocalizedString(@"Privacy", nil);
            
            self.collectionManager = [CollectionManager managerWithType:CollectionTypePrivacySettings modifierObjects:nil];
        }
            break;
        case DynamicSelctionPush:
        {
            self.title = @"Push";
            
            self.collectionManager = [CollectionManager managerWithType:CollectionTypePushSettinds modifierObjects:nil];
        }
            break;
            
        case DynamicSelctionSocials:
        {
            self.title = NSLocalizedString(@"Social networks", nil);
            [SocialManager sharedManager].delegate = self;
            self.collectionManager = [CollectionManager managerWithType:CollectionTypeSocialsSettings modifierObjects:nil];
        }
            break;
            
        default:
            break;
    }
    
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = viewControllerFrame;
    [self.view addSubview:collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionManager reloadData];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [[SocialManager sharedManager] loginTwWithUser:buttonIndex];
    }
    else
    {
        [self.collectionManager reloadData];
    }
}

@end
