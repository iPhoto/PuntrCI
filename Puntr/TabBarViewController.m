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

#import "ObjectManager.h"

typedef NS_ENUM(NSInteger, TabType)
{
    TabTypeNews,
    TabTypeCatalogue,
    TabTypeMyStakes,
    TabTypeUser
};

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
        
        
        if ([ObjectManager sharedManager].authorized)
        {
            [self setSelectedIndex:TabTypeNews];
        }
        else
        {
            [self setSelectedIndex:TabTypeCatalogue];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
