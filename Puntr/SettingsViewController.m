//
//  SettingsViewController.m
//  Puntr
//
//  Created by Artem on 8/14/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EnterViewController.h"
#import "ChangePasswordViewController.h"
#import "CopyrightViewController.h"
#import "FriendsViewController.h"
#import "ObjectManager.h"
#import "PrivacySettingsViewController.h"
#import "SettingsViewController.h"
#import "StatisticViewController.h"
#import "UpdateProfileViewController.h"
#import "UIViewController+Puntr.h"
#import <QuartzCore/QuartzCore.h>


#define TNFontHeader [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
#define TNFontFooter [UIFont boldSystemFontOfSize:11.0f]

static const CGFloat TNHeaderFooterSidePadding = 14.0f;
static const CGFloat TNHeaderFooterTopPadding = 8.0f;

#pragma mark - TableViewCell

@interface SettingsTableViewCell : UITableViewCell

@end

@implementation SettingsTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = CGPointMake(20.0f, CGRectGetMidY(self.imageView.frame));
    self.textLabel.frame = CGRectSetX(self.textLabel.frame, 40.0f);
}

@end

#pragma mark - ViewController

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableViewSettings;

@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSArray *sectionHeadersArray;
@property (nonatomic, strong) NSArray *sectionFootersArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBalanceButton];
    
    [self setupSettingsArray];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = NSLocalizedString(@"Settings", nil);
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    
    CGRect tableFrame = self.view.bounds;
    tableFrame = CGRectSetHeight(tableFrame, viewHeight - (tabBarHeight + navigationBarHeight));
    
    self.tableViewSettings = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.tableViewSettings.dataSource = self;
    self.tableViewSettings.delegate = self;
    self.tableViewSettings.backgroundView = nil;
    self.tableViewSettings.backgroundColor = [UIColor clearColor];
    self.tableViewSettings.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.tableViewSettings.scrollEnabled = YES;
    [self.view addSubview:self.tableViewSettings];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellDictionary = self.settingsArray[indexPath.section][indexPath.row];
    
    NSString *reuseIdFileName = @"middle";
    if (indexPath.row == 0)
    {
        reuseIdFileName = @"top";
    }
    if (indexPath.row == ((NSArray *)self.settingsArray[indexPath.section]).count - 1)
    {
        reuseIdFileName = @"bottom";
    }
    
    NSString *fileNameSimple = [reuseIdFileName stringByAppendingString:@".png"];
    NSString *fileNameSelected = [reuseIdFileName stringByAppendingString:@"_active.png"];
    
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:reuseIdFileName];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileNameSimple]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileNameSelected]];
    
    if (cellDictionary[@"title"])
    {
        cell.textLabel.text = cellDictionary[@"title"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    }
    
    if ((cellDictionary[@"isAccessory"]) && ([cellDictionary[@"isAccessory"] boolValue]))
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ((cellDictionary[@"pictureName"]) && (![cellDictionary[@"pictureName"] isEqualToString:@""]))
    {
        cell.imageView.image = [UIImage imageNamed:cellDictionary[@"pictureName"]];
    }
    
    return cell;
}

#pragma mark - Sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.settingsArray[section]).count;
}

#pragma mark - Headers

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self heightForHeader:YES inSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self viewForHeader:YES inSection:section];
}

#pragma mark - Footers

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self heightForHeader:NO inSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self viewForHeader:NO inSection:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cellDictionary = self.settingsArray[indexPath.section][indexPath.row];
    
    if (cellDictionary[@"performSelector"])
    {
        NSString *methodName = cellDictionary[@"performSelector"];
        SEL sel = NSSelectorFromString(methodName);
        [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - Utils

- (void)setupSettingsArray
{
    self.settingsArray = @[
                             @[
                                 @{ @"pictureName": @"1.png", @"title": NSLocalizedString(@"User profile", nil), @"performSelector": @"profileUpdateTouched", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"2.png", @"title": NSLocalizedString(@"Change Password", nil), @"performSelector": @"changePasswordTouched", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"3.png", @"title": NSLocalizedString(@"Statistics", nil), @"performSelector": @"statisticTouched", @"isAccessory": @(YES) },
                              ],
                             @[
                                 @{ @"pictureName": @"4.png", @"title": NSLocalizedString(@"Soc. networks accounts", nil), @"performSelector": @"socialsTouched", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"5.png", @"title": NSLocalizedString(@"Invite friends from social networks", nil), @"performSelector": @"friendsTouched", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"6.png", @"title": NSLocalizedString(@"Push Notifications", nil), @"performSelector": @"pushTouched", @"isAccessory": @(YES)},
                                 @{ @"pictureName": @"7.png", @"title": NSLocalizedString(@"Privacy", nil), @"performSelector": @"privacyTouched", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"8.png", @"title": NSLocalizedString(@"Log out", nil), @"performSelector": @"showExitDialog" },
                              ],
                             @[
                                 @{ @"pictureName": @"9.png", @"title": NSLocalizedString(@"Offer", nil), @"performSelector": @"offerTouched", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"10.png", @"title": NSLocalizedString(@"Terms of usage", nil), @"performSelector": @"termsTouched", @"isAccessory": @(YES) },
                              ],
                          ];
    
    self.sectionHeadersArray = @[
                                   @{ @"text": NSLocalizedString(@"Profile", nil), @"font": TNFontHeader },
                                   @{ @"text": NSLocalizedString(@"Account", nil), @"font": TNFontHeader },
                                   @{ @"text": NSLocalizedString(@"Terms", nil), @"font": TNFontHeader },
                                ];
    
    /*self.sectionFootersArray = @[
                                   @{ @"text": @"" },
                                   @{ @"text": @"Установите настройку конфиденциальности в \"Да\", если хотите, чтоб ваши действия были невидимыми всем пользователям, кроме тех, на кого вы подписались. Если другой пользователь захочет подписаться на ваши действия, вы получите запрос", @"font": TNFontFooter },
                                   @{ @"text": @"" },
                                ];*/
}

- (CGFloat)heightForHeader:(BOOL)isHeader inSection:(NSInteger)section
{
    CGFloat headerHeight = UITableViewAutomaticDimension;
    
    NSDictionary *settings;
    if (isHeader)
    {
        settings = self.sectionHeadersArray[section];
    }
    else
    {
        settings = self.sectionFootersArray[section];
    }
    
    if (settings[@"text"] && (![settings[@"text"] isEqualToString:@""]))
    {
        NSString *header = settings[@"text"];
        CGSize headerSize = [header sizeWithFont:(UIFont *)settings[@"font"]
                               constrainedToSize:CGSizeMake(CGRectGetWidth(self.tableViewSettings.frame) - (TNHeaderFooterSidePadding * 2.0f), MAXFLOAT)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        headerHeight = TNHeaderFooterTopPadding + headerSize.height + 5.0f;
    }
    return headerHeight;
}

- (UIView *)viewForHeader:(BOOL)isHeader inSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    NSDictionary *settings;
    if (isHeader)
    {
        settings = self.sectionHeadersArray[section];
    }
    else
    {
        settings = self.sectionFootersArray[section];
    }
    
    if (settings[@"text"] && (![settings[@"text"] isEqualToString:@""]))
    {
        NSString *header = settings[@"text"];
        CGFloat settingsWidth = CGRectGetWidth(self.tableViewSettings.frame);
        
        CGSize headerSize = [header sizeWithFont:(UIFont *)settings[@"font"]
                               constrainedToSize:CGSizeMake(settingsWidth - (TNHeaderFooterSidePadding * 2.0f), MAXFLOAT)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(
                                                              0.0f,
                                                              0.0f,
                                                              settingsWidth,
                                                              TNHeaderFooterTopPadding + headerSize.height + 5.0f
                                                             )];
        
        UILabel *headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                             TNHeaderFooterSidePadding,
                                                                             TNHeaderFooterTopPadding,
                                                                             settingsWidth - (TNHeaderFooterSidePadding * 2.0f),
                                                                             headerSize.height
                                                                            )];
        headerViewLabel.text = header;
        headerViewLabel.font = (UIFont *)settings[@"font"];
        headerViewLabel.backgroundColor = [UIColor clearColor];
        headerViewLabel.textColor = [UIColor whiteColor];
        headerViewLabel.lineBreakMode = NSLineBreakByWordWrapping;
        headerViewLabel.numberOfLines = 0;
        [headerView addSubview:headerViewLabel];
    }
    return headerView;
}
#pragma mark - Actions

- (void)changePasswordTouched
{
    [self.navigationController pushViewController:[[ChangePasswordViewController alloc] init] animated:YES];
}

- (void)friendsTouched
{
    [self.navigationController pushViewController:[[FriendsViewController alloc] init] animated:YES];
}

- (void)profileUpdateTouched
{
    [self.navigationController pushViewController:[[UpdateProfileViewController alloc] init] animated:YES];
}

- (void)statisticTouched
{
    [self.navigationController pushViewController:[[StatisticViewController alloc] init] animated:YES];
}

- (void)privacyTouched
{
    [self.navigationController pushViewController:[[PrivacySettingsViewController alloc] initWithDynamicSelection: DynamicSelctionPrivacy] animated:YES];
}

- (void)pushTouched
{
    [self.navigationController pushViewController:[[PrivacySettingsViewController alloc] initWithDynamicSelection: DynamicSelctionPush] animated:YES];
}

- (void)socialsTouched
{
    [self.navigationController pushViewController:[[PrivacySettingsViewController alloc] initWithDynamicSelection: DynamicSelctionSocials] animated:YES];
}

- (void)offerTouched
{
    [self.navigationController pushViewController:[[CopyrightViewController alloc] initWithCopyrightSelection:CopyrightSelectionOffer] animated:YES];
}

- (void)termsTouched
{
    [self.navigationController pushViewController:[[CopyrightViewController alloc] initWithCopyrightSelection:CopyrightSelectionTerms] animated:YES];
}

#pragma mark - ActionSheet

- (void)showExitDialog
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure?", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Log out", nil)
                                                    otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        [[ObjectManager sharedManager] logOutWithSuccess:^
            {
                EnterViewController *enterViewController = [[EnterViewController alloc] init];
                UINavigationController *enterNavigationController = [[UINavigationController alloc] initWithRootViewController:enterViewController];
                [UIView transitionWithView:[[UIApplication sharedApplication] keyWindow]
                                  duration:0.3f
                                   options:UIViewAnimationOptionTransitionFlipFromRight
                                animations:^
                                {
                                    [[[UIApplication sharedApplication] keyWindow] setRootViewController:enterNavigationController];
                                }
                                completion:nil];
            }
            failure:nil
        ];
    }
}

@end
