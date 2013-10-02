//
//  PuntrUtilities.m
//  Puntr
//
//  Created by Momus on 11.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventViewController.h"
#import "PuntrUtilities.h"
#import "UserViewController.h"
#import <CoreImage/CoreImage.h>

@implementation PuntrUtilities

+ (UINavigationController *)mainNavigationController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topController isKindOfClass:[UITabBarController class]])
    {
        UINavigationController *mainNavigationController = (UINavigationController *)[(UITabBarController *)topController selectedViewController];
        return mainNavigationController;
    }
    else if ([topController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)topController;
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

#pragma mark - Visability

+ (BOOL)isProfileVisible
{
    return [self isVisibleViewController:[UserViewController class]];
}

+ (BOOL)isEventVisible
{
    return [self isVisibleViewController:[EventViewController class]];
}

+ (BOOL)isVisibleViewController:(Class)viewControllerClass
{
    return [[self topController] isMemberOfClass:viewControllerClass] ? : NO;
}

@end
