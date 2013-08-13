//
//  SettingsViewController.m
//  Puntr
//
//  Created by Artem on 8/14/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *settingsCollectionView;

@end



@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    UICollectionView *cv = [UICollectionView new];
    self.settingsCollectionView = cv;
    [self.view addSubview:self.settingsCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDataSource


#pragma mark - UICollectionViewDelegate

@end
