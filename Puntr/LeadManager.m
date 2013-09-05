//
//  LeadManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "EventModel.h"
#import "EventsViewController.h"
#import "EventViewController.h"
#import "GroupModel.h"
#import "LeadManager.h"
#import "TournamentsViewController.h"
#import "UserModel.h"
#import "UserViewController.h"

@implementation LeadManager

+ (LeadManager *)manager
{
    return [[self alloc] init];
}

- (void)actionOnModel:(id)model
{
    if ([model isMemberOfClass:[EventModel class]])
    {
        if (![self isVisible:[EventViewController class]]) {
            [[PuntrUtilities mainNavigationController] pushViewController:[[EventViewController alloc] initWithEvent:(EventModel *)model] animated:YES];
        }
    }
    else if ([model isMemberOfClass:[UserModel class]])
    {
        if (![self isVisible:[UserViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[[UserViewController alloc] initWithUser:(UserModel *)model] animated:YES];
        }
    }
    else if ([model isMemberOfClass:[GroupModel class]])
    {
        GroupModel *group = (GroupModel *)model;
        if ([group.slug isEqualToString:KeyTournaments] && ![self isVisible:[TournamentsViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentsViewController tournaments] animated:YES];
        }
        else if (![self isVisible:[EventsViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[EventsViewController eventsForGroup:(GroupModel *)model] animated:YES];
        }
    }
}

- (BOOL)isVisible:(Class)viewControllerClass
{
    return [[PuntrUtilities topController] isMemberOfClass:viewControllerClass];
}

@end