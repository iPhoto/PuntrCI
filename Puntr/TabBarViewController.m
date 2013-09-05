//
//  TabBarViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TabBarViewController.h"
#import "NewsNavigationController.h"
#import "CatalogueNavigationController.h"
#import "MyStakesNavigationController.h"
#import "UserNavigationController.h"

#import "NewsViewController.h"
#import "CatalogueEventsViewController.h"
#import "MyStakesViewController.h"
#import "UserViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray *viewControllers = @[
                                         [[NewsNavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]],
                                         [[CatalogueNavigationController alloc] initWithRootViewController:[[CatalogueEventsViewController alloc] init]],
                                         [[MyStakesNavigationController alloc] initWithRootViewController:[[MyStakesViewController alloc] init]],
                                         [[UserNavigationController alloc] initWithRootViewController:[[UserViewController alloc] init]]
                                    ];
        [self setViewControllers:viewControllers animated:YES];
        [self setSelectedIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
