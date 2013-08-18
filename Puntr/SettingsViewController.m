//
//  SettingsViewController.m
//  Puntr
//
//  Created by Artem on 8/14/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SettingsViewController.h"
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
    self.imageView.center = CGPointMake(20, self.imageView.center.y);
    self.textLabel.frame = CGRectMake(40, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
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
    self.title = @"Настройки";
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    
    CGRect tableFrame = self.view.bounds;
    CGRectSetHeight(tableFrame, viewHeight - (tabBarHeight + navigationBarHeight));
    
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
    
    NSString *reuseIdFileName = @"middle.png";
    if (indexPath.row == 0)
    {
        reuseIdFileName = @"top.png";
    }
    if (indexPath.row == ((NSArray *)self.settingsArray[indexPath.section]).count - 1)
    {
        reuseIdFileName = @"bottom.png";
    }
    
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:reuseIdFileName];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reuseIdFileName]];
    cell.backgroundColor = [UIColor clearColor];
    
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
                                 @{ @"pictureName": @"1.png", @"title": @"Данные пользователя", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"2.png", @"title": @"Сменить пароль", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"3.png", @"title": @"Статистика", @"isAccessory": @(YES) },
                              ],
                             @[
                                 @{ @"pictureName": @"4.png", @"title": @"Аккаунты соц. сетей", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"5.png", @"title": @"Пригласить друзей из соц. сетей", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"6.png", @"title": @"Push-уведомления", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"7.png", @"title": @"Конфиденциальность" },
                                 @{ @"pictureName": @"8.png", @"title": @"Выйти", @"performSelector": @"showExitDialog" },
                              ],
                             @[
                                 @{ @"pictureName": @"9.png", @"title": @"Оферта", @"isAccessory": @(YES) },
                                 @{ @"pictureName": @"10.png", @"title": @"Условия использования" },
                              ],
                          ];
    
    self.sectionHeadersArray = @[
                                   @{ @"text": @"Профиль", @"font": TNFontHeader },
                                   @{ @"text": @"Аккаунт", @"font": TNFontHeader },
                                   @{ @"text": @"Условия", @"font": TNFontHeader },
                                ];
    
    self.sectionFootersArray = @[
                                   @{ @"text": @"" },
                                   @{ @"text": @"Установите настройку конфиденциальности в \"Да\", если хотите, чтоб ваши действия были невидимыми всем пользователям, кроме тех, на кого вы подписались. Если другой пользователь захочет подписаться на ваши действия, вы получите запрос", @"font": TNFontFooter },
                                   @{ @"text": @"" },
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

#pragma mark - ActionSheet

- (void)showExitDialog
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Вы уверены?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Выйти"
                                               destructiveButtonTitle:@"Отмена"
                                                    otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
