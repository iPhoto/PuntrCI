//
//  PuntrUtilities.m
//  Puntr
//
//  Created by Momus on 11.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PuntrUtilities.h"

@implementation PuntrUtilities

+ (UINavigationController *)mainNavigationController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topController isKindOfClass:[UITabBarController class]])
    {
        UINavigationController *mainNavigationController = (UINavigationController *)[(UITabBarController *)topController selectedViewController];
        return mainNavigationController;
    }
    else
    {
        return nil;
    }
}

+ (UIViewController *)topController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topController isKindOfClass:[UITabBarController class]])
    {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    if ([topController isKindOfClass:[UINavigationController class]])
    {
        topController = [(UINavigationController *)topController visibleViewController];
    }
    return topController;
}

@end
