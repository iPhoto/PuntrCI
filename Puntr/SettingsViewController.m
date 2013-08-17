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


#define FONT_HEADER         [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
#define FONT_FOOTER         [UIFont boldSystemFontOfSize:11.0f]

#define headerFooterSidePadding         14.0
#define headerFooterTopPadding          8.0

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

// -----------------------------------------

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UITableView *settingsTable1;

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
    
    CGRect fr = self.view.bounds;
    fr.size.height -= (CGRectGetHeight(self.tabBarController.tabBar.bounds) + CGRectGetHeight(self.navigationController.navigationBar.bounds));
    
    UITableView *tv = [[UITableView alloc] initWithFrame:fr style:UITableViewStyleGrouped];
    self.settingsTable1 = tv;
    self.settingsTable1.dataSource = self;
    self.settingsTable1.delegate = self;
    self.settingsTable1.backgroundView = nil;
    [self.settingsTable1 setBackgroundColor:[UIColor clearColor]];
    self.settingsTable1.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.settingsTable1.scrollEnabled = NO;
    [self.settingsTable1 setScrollEnabled:YES];
    [self.view addSubview:self.settingsTable1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdFileName];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reuseIdFileName]];
    cell.backgroundColor = [UIColor clearColor];
    
    if (cellDictionary[@"title"]) {
        cell.textLabel.text = cellDictionary[@"title"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    }
    
    if ((cellDictionary[@"isAccessory"]) && ([cellDictionary[@"isAccessory"] boolValue]))
    {
//        cell.accessoryView = 
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ((cellDictionary[@"pictureName"]) && (![cellDictionary[@"pictureName"] isEqualToString:@""]))
    {
        cell.imageView.image = [UIImage imageNamed:cellDictionary[@"pictureName"]];
    }
    
    return cell;
}


// --- sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = ((NSArray *)self.settingsArray[section]).count;
    return number;
}

// --- headers
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeader:YES inSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeader:YES inSection:section];
}

// --- footers
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForHeader:NO inSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewForHeader:NO inSection:section];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cellDictionary = self.settingsArray[indexPath.section][indexPath.row];
    
    if (cellDictionary[@"performSelector"])
    {
        NSString * methodName = cellDictionary[@"performSelector"];
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
                                   @{ @"pictureName": @"7.png", @"title": @"Конфиденциальность"},
                                   @{ @"pictureName": @"8.png", @"title": @"Выйти", @"performSelector": @"showExitDialog"},
                                ],
                               @[
                                   @{ @"pictureName": @"9.png", @"title": @"Оферта", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"10.png", @"title": @"Условия использования"},
                                ],
                         ];
    
    self.sectionHeadersArray = @[
                                 @{ @"text": @"Профиль", @"font": FONT_HEADER},
                                 @{ @"text": @"Аккаунт", @"font": FONT_HEADER},
                                 @{ @"text": @"Условия", @"font": FONT_HEADER},
                                 ];
    
    self.sectionFootersArray = @[
                                 @{ @"text": @""},
                                 @{ @"text": @"Установите настройку конфиденциальности в \"Да\", если хотите, чтоб ваши действия были невидимыми всем пользователям, кроме тех, на кого вы подписались. Если другой пользователь захочет подписаться на ваши действия, вы получите запрос", @"font": FONT_FOOTER},
                                 @{ @"text": @""},
                                 ];
}

- (CGFloat)heightForHeader:(BOOL)isHeader inSection:(NSInteger)section
{
    CGFloat retVal = UITableViewAutomaticDimension;
    
    NSDictionary *dic;
    if (isHeader)
    {
        dic = self.sectionHeadersArray[section];
    }
    else
    {
        dic = self.sectionFootersArray[section];
    }
    
    if (dic[@"text"] && (![dic[@"text"] isEqualToString:@""]))
    {
        NSString *header = dic[@"text"];
        CGSize headerSize = [header sizeWithFont:(UIFont *)dic[@"font"] constrainedToSize:CGSizeMake(self.settingsTable1.frame.size.width - (headerFooterSidePadding*2), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        retVal = headerFooterTopPadding + headerSize.height + 5;
    }
    return retVal;
}

- (UIView *)viewForHeader:(BOOL)isHeader inSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    NSDictionary *dic;
    if (isHeader)
    {
        dic = self.sectionHeadersArray[section];
    }
    else
    {
        dic = self.sectionFootersArray[section];
    }
    
    if (dic[@"text"] && (![dic[@"text"] isEqualToString:@""]))
    {
        NSString *header = dic[@"text"];
        CGSize headerSize = [header sizeWithFont:(UIFont *)dic[@"font"] constrainedToSize:CGSizeMake(self.settingsTable1.frame.size.width - (headerFooterSidePadding*2), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.settingsTable1.frame.size.width, headerFooterTopPadding + headerSize.height + 5)];
        //headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerFooterSidePadding, headerFooterTopPadding, self.settingsTable1.frame.size.width - (headerFooterSidePadding*2), headerSize.height)];
        headerViewLabel.text = header;
        headerViewLabel.font = (UIFont *)dic[@"font"];
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
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Вы уверены?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Выйти"
                                               destructiveButtonTitle:@"Отмена"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
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


//    self.textFieldLogin.text = @"qqq@gmail.com";
//    self.textFieldPassword.text = @"qqqqqq";


