//
//  SettingsViewController.m
//  Puntr
//
//  Created by Artem on 8/14/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>


#define TABLE_CELLS_HEIGHT 30.0

#define FONT_CONF_LABEL     [UIFont fontWithName:@"Arial-BoldMT" size:11.0f]

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *settingsTable1;
@property (nonatomic, weak) UITableView *settingsTable2;
@property (nonatomic, weak) UITableView *settingsTable3;

@property (nonatomic, strong) NSArray *settingsArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSettingsArray];
    
    CGRect fullScreen = [UIScreen mainScreen].bounds;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    UIScrollView *bkScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    [self.view addSubview:bkScrollView];
    
    
    CGFloat padding = 10;
    CGFloat currentTop = 10;
    
    self.title = @"Настройки";
    
    UILabel *titleLabel;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, currentTop, 280, 35)];
    titleLabel.text = @"Профиль";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bkScrollView addSubview:titleLabel];
    
    currentTop += CGRectGetHeight(titleLabel.frame);
    
    NSInteger tableTag;
    UITableView *tv;
    UIImage *backgroundImage = [[UIImage imageNamed:@"settingsBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 17.0f)];
    
    tableTag = 0;
    tv = [[UITableView alloc] initWithFrame:CGRectMake(padding, currentTop, CGRectGetWidth(fullScreen) - (padding * 2), TABLE_CELLS_HEIGHT * ((NSArray *)self.settingsArray[tableTag]).count - 2) style:UITableViewStylePlain];
    self.settingsTable1 = tv;
    self.settingsTable1.dataSource = self;
    self.settingsTable1.delegate = self;
    self.settingsTable1.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.settingsTable1.layer.cornerRadius = 2.5;
    [self.settingsTable1 setBackgroundColor:[UIColor clearColor]];
    self.settingsTable1.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.settingsTable1.scrollEnabled = NO;
    self.settingsTable1.tag = tableTag;
    [bkScrollView addSubview:self.settingsTable1];
    
    currentTop += CGRectGetHeight(self.settingsTable1.frame);
    currentTop += 10;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, currentTop, 280, 35)];
    titleLabel.text = @"Аккаунт";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bkScrollView addSubview:titleLabel];
    
    currentTop += CGRectGetHeight(titleLabel.frame);
    
    tableTag++;
    tv = [[UITableView alloc] initWithFrame:CGRectMake(padding, currentTop, CGRectGetWidth(fullScreen) - (padding * 2), TABLE_CELLS_HEIGHT * ((NSArray *)self.settingsArray[tableTag]).count - 2) style:UITableViewStylePlain];
    self.settingsTable2 = tv;
    self.settingsTable2.dataSource = self;
    self.settingsTable2.delegate = self;
    self.settingsTable2.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.settingsTable2.layer.cornerRadius = 2.5;
    [self.settingsTable2 setBackgroundColor:[UIColor clearColor]];
    self.settingsTable2.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.settingsTable2.scrollEnabled = NO;
    self.settingsTable2.tag = tableTag;
    [bkScrollView addSubview:self.settingsTable2];
    
    currentTop += CGRectGetHeight(self.settingsTable2.frame);
    currentTop += 10;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, currentTop, 280, 80)];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = @"Установите настройку конфиденциальности в \"Да\", если хотите, чтоб ваши действия были невидимыми всем пользователям, кроме тех, на кого вы подписались. Если другой пользователь захочет подписаться на ваши действия, вы получите запрос";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FONT_CONF_LABEL;
    titleLabel.backgroundColor = [UIColor clearColor];
    [bkScrollView addSubview:titleLabel];
    
    currentTop += CGRectGetHeight(titleLabel.frame);
    currentTop += 10;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, currentTop, 280, 35)];
    titleLabel.text = @"Условия";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bkScrollView addSubview:titleLabel];
    
    currentTop += CGRectGetHeight(titleLabel.frame);
    
    tableTag++;
    tv = [[UITableView alloc] initWithFrame:CGRectMake(padding, currentTop, CGRectGetWidth(fullScreen) - (padding * 2), TABLE_CELLS_HEIGHT * ((NSArray *)self.settingsArray[tableTag]).count - 2) style:UITableViewStylePlain];
    self.settingsTable3 = tv;
    self.settingsTable3.dataSource = self;
    self.settingsTable3.delegate = self;
    self.settingsTable3.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.settingsTable3.layer.cornerRadius = 2.5;
    [self.settingsTable3 setBackgroundColor:[UIColor clearColor]];
    self.settingsTable3.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.settingsTable3.scrollEnabled = NO;
    self.settingsTable3.tag = tableTag;
    [bkScrollView addSubview:self.settingsTable3];

    currentTop += CGRectGetHeight(self.settingsTable3.frame);
    currentTop += 10;
    
    bkScrollView.contentSize = CGSizeMake(bkScrollView.frame.size.width, currentTop);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELLS_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat pictureWidth = 150;
    
    NSDictionary *cellDictionary = self.settingsArray[tableView.tag][indexPath.item];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    if ([cellDictionary[@"isAccessory"] boolValue])
    {
//        cell.accessoryView = 
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = cellDictionary[@"title"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    if (![cellDictionary[@"pictureName"] isEqualToString:@""])
    {
        cell.imageView.image = [UIImage imageNamed:cellDictionary[@"pictureName"]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = ((NSArray *)self.settingsArray[tableView.tag]).count;
    return number;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                                   @{ @"pictureName": @"5.png", @"title": @"Пригласить друзей из соцюсетей", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"6.png", @"title": @"Push-уведомления", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"7.png", @"title": @"Конфиденциальность", @"isAccessory": @(NO) },
                                   @{ @"pictureName": @"8.png", @"title": @"Выйти", @"isAccessory": @(NO) },
                                ],
                               @[
                                   @{ @"pictureName": @"9.png", @"title": @"Оферта", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"10.png", @"title": @"Условия использования", @"isAccessory": @(YES) },
                                ],
                         ];
}

@end
