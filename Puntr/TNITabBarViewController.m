//
//  TNITabBarViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNITabBarViewController.h"
#import "TNINewsNavigationController.h"
#import "TNICatalogueNavigationController.h"
#include "TNIMyStakesNavigationController.h"
#include "TNIProfileNavigationController.h"

#import "TNINewsViewController.h"
#import "TNICatalogueViewController.h"
#import "TNIMyStakesViewController.h"
#import "TNIProfileViewController.h"

@interface TNITabBarViewController ()

@end

@implementation TNITabBarViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *viewControllers = @[[[TNINewsNavigationController alloc] initWithRootViewController:[[TNINewsViewController alloc] init]],
                                     [[TNICatalogueNavigationController alloc] initWithRootViewController:[[TNICatalogueViewController alloc] init]],
                                     [[TNIMyStakesNavigationController alloc] initWithRootViewController:[[TNIMyStakesViewController alloc] init]],
                                     [[TNIProfileNavigationController alloc] initWithRootViewController:[[TNIProfileViewController alloc] init]]];
        [self setViewControllers:viewControllers animated:YES];
        [self setSelectedIndex:1];
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

@end
