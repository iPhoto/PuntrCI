//
//  LeadManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//


#import "AwardsCollectionViewController.h"
#import "CatalogueEventsViewController.h"
#import "CatalogueTournamentsViewController.h"
#import "EventsViewController.h"
#import "EventViewController.h"
#import "LeadManager.h"
#import "Models.h"
#import "ParticipantViewController.h"
#import "SubscribersViewController.h"
#import "SubscriptionsViewController.h"
#import "TournamentsViewController.h"
#import "TournamentViewController.h"
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
    else if ([model isMemberOfClass:[GroupModel class]])
    {
        GroupModel *group = (GroupModel *)model;
        if ([group.slug isEqualToString:KeyTournaments] && ![self isVisible:[CatalogueTournamentsViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[CatalogueTournamentsViewController tournaments] animated:YES];
        }
        else
        {
            if ([self isVisible:[CatalogueEventsViewController class]] && ![self isVisible:[EventsViewController class]])
            {
                CatalogueEventsViewController *catalogueEventsViewController = (CatalogueEventsViewController *)[PuntrUtilities topController];
                SearchModel *search = catalogueEventsViewController.search;
                [[PuntrUtilities mainNavigationController] pushViewController:[EventsViewController eventsForGroup:(GroupModel *)model tournament:nil search:search] animated:YES];
            }
            else if ([self isVisible:[CatalogueTournamentsViewController class]] && ![self isVisible:[TournamentsViewController class]])
            {
                CatalogueTournamentsViewController *catalogueTournamentsViewController = (CatalogueTournamentsViewController *)[PuntrUtilities topController];
                SearchModel *search = catalogueTournamentsViewController.search;
                [[PuntrUtilities mainNavigationController] pushViewController:[TournamentsViewController tournamentsForGroup:(GroupModel *)model search:search] animated:YES];
            }
            else if ([self isVisible:[TournamentViewController class]] && ![self isVisible:[EventsViewController class]])
            {
                TournamentViewController *tournamentViewController = (TournamentViewController *)[PuntrUtilities topController];
                [[PuntrUtilities mainNavigationController] pushViewController:[EventsViewController eventsForGroup:(GroupModel *)model tournament:tournamentViewController.tournament search:nil] animated:YES];
            }
        }
    }
    else if ([model isMemberOfClass:[ParticipantModel class]])
    {
        if (![self isVisible:[ParticipantViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[ParticipantViewController controllerWithParticipant:(ParticipantModel *)model] animated:YES];
        }
    }
    else if ([model isMemberOfClass:[UserDetailsModel class]])
    {
        UserDetailsModel *userDetails = (UserDetailsModel *)model;
        switch (userDetails.userDetailsType)
        {
            case UserDetailsTypeSubscriptions:
                [[PuntrUtilities mainNavigationController] pushViewController:[SubscriptionsViewController subscriptionsForUser:userDetails.user] animated:YES];
                break;
                
            case UserDetailsTypeSubscribers:
                [[PuntrUtilities mainNavigationController] pushViewController:[SubscribersViewController subscribersForUser:userDetails.user] animated:YES];
                break;
                
            case UserDetailsTypeAwards:
                [[PuntrUtilities mainNavigationController] pushViewController:[[AwardsCollectionViewController alloc] initWithUser:userDetails.user] animated:YES];
                break;
                
            default:
                break;
        }
    }
    else if ([model isMemberOfClass:[UserModel class]])
    {
        BOOL allowTransition = NO;
        if (![self isVisible:[UserViewController class]])
        {
            allowTransition = YES;
        }
        else
        {
            UserModel *user = model;
            UserViewController *userViewController = (UserViewController *)[PuntrUtilities topController];
            if (![user.tag isEqualToNumber:userViewController.user.tag])
            {
                allowTransition = YES;
            }
        }
        
        if (allowTransition)
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[[UserViewController alloc] initWithUser:(UserModel *)model] animated:YES];
        }
    }
    else if ([model isMemberOfClass:[TournamentModel class]])
    {
        if (![self isVisible:[TournamentViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model] animated:YES];
        }
    }
}

- (BOOL)isVisible:(Class)viewControllerClass
{
    return [[PuntrUtilities topController] isMemberOfClass:viewControllerClass];
}

@end
