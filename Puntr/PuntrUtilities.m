//
//  PuntrUtilities.m
//  Puntr
//
//  Created by Momus on 11.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventsViewController.h"
#import "EventViewController.h"
#import "PuntrUtilities.h"
#import "TournamentViewController.h"
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

+ (BOOL)isEventVisible
{
    return [self isVisibleViewController:[EventViewController class]];
}

+ (BOOL)isProfileVisible
{
    return [self isVisibleViewController:[UserViewController class]];
}

+ (BOOL)isTournamentVisible
{
    if ([self isVisibleViewController:[TournamentViewController class]])
    {
        return YES;
    }
    else if ([self isVisibleViewController:[EventsViewController class]])
    {
        EventsViewController *eventsViewController = (EventsViewController *)[self topController];
        if (eventsViewController.tournament)
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isVisibleViewController:(Class)viewControllerClass
{
    return [[self topController] isMemberOfClass:viewControllerClass] ? : NO;
}



@end
