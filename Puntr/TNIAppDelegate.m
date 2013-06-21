//
//  TNIAppDelegate.m
//  Puntr
//
//  Created by Eugene Tulushev on 28.05.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIAppDelegate.h"
#import "TNIEnterViewController.h"
#import "TNITabBarViewController.h"
#import "TNICatalogueNavigationController.h"
#import "TNITextField.h"
#import "TNIHTTPClient.h"
#import "TNIObjectManager.h"

@interface TNIAppDelegate ()

@property (nonatomic, strong) TNITabBarViewController *tabBarViewController;

@end

@implementation TNIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    //  Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#endif
    // Networking
    TNIHTTPClient *client = [TNIHTTPClient sharedClient];
    TNIObjectManager *objectManager = [[TNIObjectManager alloc] initWithHTTPClient:client];
    [objectManager configureMapping];
    //  Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    TNIEnterViewController *enter = [[TNIEnterViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:enter];
    [self.window makeKeyAndVisible];
    
    [self applyStylesheet];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    
    return YES;
}

#pragma mark - Style

- (void)applyStylesheet {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navigationBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(44.0f, 0.0f, 44.0f, 0.0f)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.180 alpha:1.000]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                     UITextAttributeFont: [UIFont fontWithName:@"Arial-BoldMT" size:21.0f],
                                UITextAttributeTextColor: [UIColor colorWithWhite:0.996 alpha:1.000],
                          UITextAttributeTextShadowColor: [UIColor blackColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.5f)]}];
    
    [[TNITextField appearance] setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17.0f]];
    [[TNITextField appearance] setTextColor:[UIColor colorWithWhite:0.200 alpha:1.000]];
    [[TNITextField appearance] setBackground:[[UIImage imageNamed:@"textField"] resizableImageWithCapInsets:UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f)]];
    [[TNITextField appearance] setVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[TNITextField appearance] setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tabBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(49.0f, 0.0f, 49.0f, 0.0f)]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected"]];
    [[UITabBar appearance] setShadowImage:[[UIImage imageNamed:@"tabBarShadow"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
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
