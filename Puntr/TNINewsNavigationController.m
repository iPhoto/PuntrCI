//
//  TNINewsNavigationController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNINewsNavigationController.h"

@interface TNINewsNavigationController ()

@end

@implementation TNINewsNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Новости" image:nil tag:1];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarNewsSelected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarNews"]];
}

@end