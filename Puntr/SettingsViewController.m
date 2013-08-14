//
//  SettingsViewController.m
//  Puntr
//
//  Created by Artem on 8/14/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

#define TABLE_CELLS_HEIGHT 20.0

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
    CGFloat padding = 10;
    CGFloat currentTop = 10;
    
    self.title = @"Настройки";
    
    UILabel *titleLabel;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, currentTop, 280, 35)];
    titleLabel.text = @"Профиль";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    currentTop += titleLabel.frame.size.height;
    
    NSInteger tableTag;
    UITableView *tv;
    UIImage *backgroundImage = [[UIImage imageNamed:@"catalogueHeaderBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 17.0f)];
    
    tableTag = 0;
    tv = [[UITableView alloc] initWithFrame:CGRectMake(padding, currentTop, fullScreen.size.width - (padding * 2), TABLE_CELLS_HEIGHT * ((NSArray *)self.settingsArray[tableTag]).count - 2) style:UITableViewStylePlain];
    self.settingsTable1 = tv;
    self.settingsTable1.dataSource = self;
    self.settingsTable1.delegate = self;
    self.settingsTable1.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.settingsTable1.layer.cornerRadius = 2.5;
    [self.settingsTable1 setBackgroundColor:[UIColor clearColor]];
    self.settingsTable1.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.settingsTable1.scrollEnabled = NO;
    self.settingsTable1.tag = tableTag;
    [self.view addSubview:self.settingsTable1];
    
    currentTop += self.settingsTable1.frame.size.height;
    currentTop += 10;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, currentTop, 280, 35)];
    titleLabel.text = @"Аккаунт";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    currentTop += titleLabel.frame.size.height;
    
    tableTag++;
    tv = [[UITableView alloc] initWithFrame:CGRectMake(padding, currentTop, fullScreen.size.width - (padding * 2), TABLE_CELLS_HEIGHT * ((NSArray *)self.settingsArray[tableTag]).count - 2) style:UITableViewStylePlain];
    self.settingsTable2 = tv;
    self.settingsTable2.dataSource = self;
    self.settingsTable2.delegate = self;
    self.settingsTable2.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.settingsTable2.layer.cornerRadius = 2.5;
    [self.settingsTable2 setBackgroundColor:[UIColor clearColor]];
    self.settingsTable2.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.settingsTable2.scrollEnabled = NO;
    self.settingsTable2.tag = tableTag;
    [self.view addSubview:self.settingsTable2];
    
    currentTop += self.settingsTable2.frame.size.height;
    currentTop += 10;
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
    NSDictionary *cellDictionary = self.settingsArray[tableView.tag][indexPath.item];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    if ([cellDictionary[@"isAccessory"] boolValue])
    {
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
                                   @{ @"pictureName": @"", @"title": @"qwe1", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"", @"title": @"qwe2", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"", @"title": @"qwe3", @"isAccessory": @(NO) },
                                ],
                               @[
                                   @{ @"pictureName": @"", @"title": @"1", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"", @"title": @"2", @"isAccessory": @(NO) },
                                   @{ @"pictureName": @"", @"title": @"3", @"isAccessory": @(NO) },
                                   @{ @"pictureName": @"", @"title": @"4", @"isAccessory": @(YES) },
                                   @{ @"pictureName": @"", @"title": @"5", @"isAccessory": @(YES) },
                                ],
                         ];
}

@end
