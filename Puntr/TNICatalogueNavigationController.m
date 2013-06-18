//
//  TNICatalogueNavigationController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNICatalogueNavigationController.h"

@interface TNICatalogueNavigationController ()

@end

@implementation TNICatalogueNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Каталог" image:nil tag:2];
}

@end
