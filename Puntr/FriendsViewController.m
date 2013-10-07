//
//  FriendsViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/26/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "FriendsViewController.h"
#import "InviteFriendsViewController.h"
#import "UIViewController+Puntr.h"

#import "ObjectManager.h"
#import "Models.h"
#import "NotificationManager.h"
#import "SocialManager.h"

#import <QuartzCore/QuartzCore.h>

#define TNFontHeader [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
#define TNFontFooter [UIFont boldSystemFontOfSize:11.0f]

static const CGFloat TNHeaderFooterSidePadding = 14.0f;
static const CGFloat TNHeaderFooterTopPadding = 8.0f;

#pragma mark - TableViewCell

@interface FriendsTableViewCell : UITableViewCell

@end

@implementation FriendsTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = CGPointMake(20.0f, CGRectGetMidY(self.imageView.frame));
    self.textLabel.frame = CGRectSetX(self.textLabel.frame, 40.0f);
}

@end

#pragma mark - ViewController

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableViewSettings;

@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSArray *sectionHeadersArray;
@property (nonatomic, strong) NSArray *sectionFootersArray;

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBalanceButton];
    
    [self setupSettingsArray];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = NSLocalizedString(@"Friends", nil);
    
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
    
    FriendsTableViewCell *cell = [[FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
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
                               //@{ @"pictureName": @"icon_vk", @"title": NSLocalizedString(@"VKontakte", nil), @"performSelector": @"vkTouched", @"isAccessory": @(YES) },
                               @{ @"pictureName": @"icon_fb", @"title": @"Facebook", @"performSelector": @"fbTouched", @"isAccessory": @(YES) },
                               @{ @"pictureName": @"icon_tw", @"title": @"Twitter", @"performSelector": @"twTouched", @"isAccessory": @(YES) },
                               ],
                           ];
    
    self.sectionHeadersArray = @[
                                 @{ @"text": NSLocalizedString(@"Social networks", nil), @"font": TNFontHeader }
                                ];
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
/*
- (void)vkTouched
{
    [NotificationManager showNotificationMessage:@"Приглашение через ВКонтакте еще не реализовано"];
}
*/
- (void)fbTouched
{
    UserModel *user =  [ObjectManager sharedManager].loginedUser;
    if (![user.socials.facebook boolValue])
    {
        [NotificationManager showNotificationMessage: NSLocalizedString(@"Facebook not", nil)];
        return;
    }
    [[PuntrUtilities mainNavigationController] pushViewController:[InviteFriendsViewController friendsForSocialNetworkType:SocialNetworkTypeFacebook] animated:YES];
    
    [[SocialManager sharedManager] getUserFriendsWithSocialNetworkOfType:SocialNetworkTypeFacebook
    success:^(AccessModel *accessModel)
    {
        
    }
    failure:^(NSError *error)
    {
        if (error)
        {
            [NotificationManager showNotificationMessage:[NSString stringWithFormat:@"%@ \n%@", NSLocalizedString(@"Failure to get a list of friends!", nil), error.localizedDescription]];
        }
    }];
}

- (void)twTouched
{
    [NotificationManager showNotificationMessage:@"Приглашение через Twitter еще не реализовано"];
}



@end
