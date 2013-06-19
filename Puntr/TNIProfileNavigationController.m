//
//  TNIProfileNavigationController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIProfileNavigationController.h"

@interface TNIProfileNavigationController ()

@end

@implementation TNIProfileNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Профиль" image:nil tag:4];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarProfileSelected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarProfile"]];
}

@end
