//
//  CatalogueNavigationController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CatalogueNavigationController.h"

@interface CatalogueNavigationController ()

@end

@implementation CatalogueNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Каталог" image:nil tag:2];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarCatalogueSelected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarCatalogue"]];
}

@end
