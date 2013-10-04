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
#import "ParticipantsViewController.h"
#import "StakeViewController.h"
#import "SubscribersViewController.h"
#import "SubscriptionsViewController.h"
#import "TournamentsViewController.h"
#import "TournamentViewController.h"
#import "UserViewController.h"
#import "UsersViewController.h"

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
        if ([self isVisible:[CatalogueEventsViewController class]] && [group.slug isEqualToString:KeyTournaments])
        {
            CatalogueEventsViewController *catalogueEventsViewController = (CatalogueEventsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueEventsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[CatalogueTournamentsViewController tournamentsWithSearch:search] animated:YES];
        }
        else if ([self isVisible:[CatalogueEventsViewController class]] && [group.slug isEqualToString:KeyUsers])
        {
            CatalogueEventsViewController *catalogueEventsViewController = (CatalogueEventsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueEventsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[UsersViewController usersWithSearch:search] animated:YES];
        }
        else if ([self isVisible:[CatalogueEventsViewController class]] && [group.slug isEqualToString:KeyParticipants])
        {
            CatalogueEventsViewController *catalogueEventsViewController = (CatalogueEventsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueEventsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[ParticipantsViewController participantsWithSearch:search] animated:YES];
        }
        else if ([self isVisible:[CatalogueEventsViewController class]])
        {
            CatalogueEventsViewController *catalogueEventsViewController = (CatalogueEventsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueEventsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[EventsViewController eventsForGroup:(GroupModel *)model tournament:nil search:search] animated:YES];
        }
        else if ([self isVisible:[CatalogueTournamentsViewController class]])
        {
            CatalogueTournamentsViewController *catalogueTournamentsViewController = (CatalogueTournamentsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueTournamentsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentsViewController tournamentsForGroup:(GroupModel *)model search:search] animated:YES];
        }
        else if ([self isVisible:[TournamentViewController class]])
        {
            TournamentViewController *tournamentViewController = (TournamentViewController *)[PuntrUtilities topController];
            SearchModel *search = tournamentViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[EventsViewController eventsForGroup:(GroupModel *)model tournament:tournamentViewController.tournament search:search] animated:YES];
        }
    }
    else if ([model isMemberOfClass:[ParticipantModel class]])
    {
        if (![self isVisible:[ParticipantViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[ParticipantViewController controllerWithParticipant:(ParticipantModel *)model] animated:YES];
        }
    }
    else if ([model isMemberOfClass:[StakeModel class]])
    {
        StakeModel *stake = (StakeModel *)model;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[StakeViewController stakeWithEvent:stake.event]];
        [[PuntrUtilities mainNavigationController] presentViewController:navigationController animated:YES completion:nil];
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
        if (![self isVisible:[TournamentsViewController class]] &&
            ![self isVisible:[CatalogueTournamentsViewController class]] &&
            ![self isVisible:[TournamentViewController class]] &&
            ![self isVisible:[CatalogueEventsViewController class]] &&
            ![self isVisible:[EventsViewController class]] &&
            ![self isVisible:[UsersViewController class]] &&
            ![self isVisible:[ParticipantsViewController class]])
        {
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:nil] animated:YES];
        }
        else if ([self isVisible:[TournamentsViewController class]])
        {
            TournamentsViewController *tournamentsViewController = (TournamentsViewController *)[PuntrUtilities topController];
            SearchModel *search = tournamentsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
        }
        else if ([self isVisible:[CatalogueTournamentsViewController class]])
        {
            CatalogueTournamentsViewController *catalogueTournamentsViewController = (CatalogueTournamentsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueTournamentsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
        }
        else if ([self isVisible:[TournamentViewController class]])
        {
            TournamentViewController *tournamentViewController = (TournamentViewController *)[PuntrUtilities topController];
            SearchModel *search = tournamentViewController.search;
            
            TournamentModel *tournament = (TournamentModel *)model;
            if (![tournamentViewController.tournament.tag isEqualToNumber:tournament.tag])
            {
                [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
            }
        }
        else if ([self isVisible:[CatalogueEventsViewController class]])
        {
            CatalogueEventsViewController *catalogueEventsViewController = (CatalogueEventsViewController *)[PuntrUtilities topController];
            SearchModel *search = catalogueEventsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
        }
        else if ([self isVisible:[EventsViewController class]])
        {
            EventsViewController *eventsViewController = (EventsViewController *)[PuntrUtilities topController];
            SearchModel *search = eventsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
        }
        else if ([self isVisible:[UsersViewController class]])
        {
            UsersViewController *usersViewController = (UsersViewController *)[PuntrUtilities topController];
            SearchModel *search = usersViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
        }
        else if ([self isVisible:[ParticipantsViewController class]])
        {
            ParticipantsViewController *participantsViewController = (ParticipantsViewController *)[PuntrUtilities topController];
            SearchModel *search = participantsViewController.search;
            [[PuntrUtilities mainNavigationController] pushViewController:[TournamentViewController controllerForTournament:(TournamentModel *)model search:search] animated:YES];
        }
    }
}

- (BOOL)isVisible:(Class)viewControllerClass
{
    return [[PuntrUtilities topController] isMemberOfClass:viewControllerClass];
}

@end
