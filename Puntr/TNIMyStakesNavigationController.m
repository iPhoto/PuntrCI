//
//  TNIMyStakesNavigationController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIMyStakesNavigationController.h"

@interface TNIMyStakesNavigationController ()

@end

@implementation TNIMyStakesNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Мои ставки" image:nil tag:3];
}

@end
