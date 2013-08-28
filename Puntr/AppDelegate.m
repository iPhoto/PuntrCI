//
//  AppDelegate.m
//  Puntr
//
//  Created by Eugene Tulushev on 28.05.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "CatalogueNavigationController.h"
#import "EnterViewController.h"
#import "HTTPClient.h"
#import "ObjectManager.h"
#import <PonyDebugger/PonyDebugger.h>
#import "SmallStakeButton.h"
#import "SocialManager.h"
#import "TabBarViewController.h"
#import "TextField.h"

@interface AppDelegate ()

@property (nonatomic, strong) TabBarViewController *tabBarViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Networking
    HTTPClient *client = [HTTPClient sharedClient];
    ObjectManager *objectManager = [[ObjectManager alloc] initWithHTTPClient:client];
    [objectManager configureMapping];
    RKLogConfigureByName("*", RKLogLevelOff)
    // Debug
#ifdef DEBUG
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger autoConnect];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
#endif
    //  Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    EnterViewController *enter = [[EnterViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:enter];
    [self.window makeKeyAndVisible];
    
    [self applyStylesheet];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    
    return YES;
}

#pragma mark - Style

- (void)applyStylesheet
{
    // NavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navigationBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsZero] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.180 alpha:1.000]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                     UITextAttributeFont: [UIFont fontWithName:@"Arial-BoldMT" size:21.0f],
                                UITextAttributeTextColor: [UIColor colorWithWhite:0.996 alpha:1.000],
                          UITextAttributeTextShadowColor: [UIColor blackColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.5f)]
     }];
    // TextField
    [[TextField appearance] setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17.0f]];
    [[TextField appearance] setTextColor:[UIColor colorWithWhite:0.200 alpha:1.000]];
    [[TextField appearance] setBackground:[[UIImage imageNamed:@"textField"] resizableImageWithCapInsets:UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f)]];
    [[TextField appearance] setVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[TextField appearance] setClearButtonMode:UITextFieldViewModeWhileEditing];
    // TabBar
    [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tabBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected"]];
    [[UITabBar appearance] setShadowImage:[[UIImage imageNamed:@"tabBarShadow"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
    // SegmentedControl
    [[UISegmentedControl appearance] setBackgroundImage:[[UIImage imageNamed:@"ButtonControlNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:[[UIImage imageNamed:@"ButtonControlSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"ButtonControlNormalNormal"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"ButtonControlNormalSelected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"ButtonControlSelectedNormal"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // BarButtonItem
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"ButtonBarBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 6.0f)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // Toolbar
    [[UIToolbar appearance] setBackgroundImage:[[UIImage imageNamed:@"BarDown"] resizableImageWithCapInsets:UIEdgeInsetsZero] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    // Small Stake Button
     [[SmallStakeButton appearance] setBackgroundImage:[[UIImage imageNamed:@"ButtonGreenSmall"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)]
                                              forState:UIControlStateNormal];
     [[SmallStakeButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [[SmallStakeButton appearance] setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:0.200] forState:UIControlStateNormal];
     [[UILabel appearanceWhenContainedIn:[SmallStakeButton class], nil] setShadowOffset:CGSizeMake(0.0f, -1.5f)];
     // Switch
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:0.202 green:0.638 blue:0.073 alpha:1.000]];
}

#pragma mark - Application Delegate

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
