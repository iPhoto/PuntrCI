//
//  MyStakesNavigationController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "MyStakesNavigationController.h"

@interface MyStakesNavigationController ()

@end

@implementation MyStakesNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"My stakes", nil) image:nil tag:3];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarStakesSelected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarStakes"]];
}

@end
