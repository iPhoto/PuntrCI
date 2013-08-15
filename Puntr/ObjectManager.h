//
//  ObjectManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RKObjectManager.h"

@class AuthorizationModel, CoefficientModel, CommentModel, CredentialsModel, EventModel, FilterModel, LineModel, MoneyModel, PagingModel, RegistrationModel, StakeModel, UserModel;

typedef void (^EmptySuccess)();
typedef void (^EmptyFailure)();

typedef void (^ObjectRequestSuccess)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^ObjectRequestFailure)(RKObjectRequestOperation *operation, NSError *error);

typedef void (^Activities)(NSArray *activities);
typedef void (^AuthorizationUser)(AuthorizationModel *authorization, UserModel *user);
typedef void (^Categories)(NSArray *categories);
typedef void (^Coefficient)(CoefficientModel *coefficient);
typedef void (^Comments)(NSArray *comments);
typedef void (^Components)(NSArray *components);
typedef void (^Events)(NSArray *events);
typedef void (^Groups)(NSArray *groups);
typedef void (^Money)(MoneyModel *money);
typedef void (^News)(NSArray *news);
typedef void (^Stake)(StakeModel *stake);
typedef void (^Stakes)(NSArray *stakes);
typedef void (^Subscribers)(NSArray *subscribers);
typedef void (^Subscriptions)(NSArray *subscriptions);
typedef void (^Tag)(NSNumber *tag);
typedef void (^Tournaments)(NSArray *tournaments);
typedef void (^User)(UserModel *user);

@interface ObjectManager : RKObjectManager

- (void)configureMapping;

#pragma mark - Authorization

- (void)logInWithCredentials:(CredentialsModel *)credentials success:(AuthorizationUser)success failure:(EmptyFailure)failure;

- (void)logOutWithSuccess:(EmptySuccess)success failure:(EmptyFailure)failure;

#pragma mark - Categories

- (void)categoriesWithSuccess:(Categories)success failure:(EmptyFailure)failure;

#pragma mark - Comments

- (void)commentsForEvent:(EventModel *)event
                  paging:(PagingModel *)paging
                 success:(Comments)success
                 failure:(EmptyFailure)failure;

- (void)postComment:(CommentModel *)comment
           forEvent:(EventModel *)event
            success:(EmptySuccess)success
            failure:(EmptyFailure)failure;

#pragma mark - Events

- (void)eventsWithPaging:(PagingModel *)paging
                  filter:(FilterModel *)filter
                 success:(Events)success
                 failure:(EmptyFailure)failure;

#pragma mark - Events Compatibility

- (void)eventsWithFilter:(FilterModel *)filter
                  paging:(PagingModel *)paging
                 success:(Events)success
                 failure:(EmptyFailure)failure;

- (void)eventsForGroup:(NSString *)group
                 limit:(NSNumber *)limit
               success:(ObjectRequestSuccess)success
               failure:(ObjectRequestFailure)failure;

- (void)eventsForGroup:(NSString *)group
                filter:(NSArray *)categoryTags
                search:(NSString *)search
                 limit:(NSNumber *)limit
                  page:(NSNumber *)page
               success:(ObjectRequestSuccess)success
               failure:(ObjectRequestFailure)failure;

#pragma mark - Groups

- (void)groupsWithSuccess:(Groups)success failure:(EmptyFailure)failure;

#pragma mark - Stakes

- (void)componentsForEvent:(EventModel *)event
                      line:(LineModel *)line
                   success:(ObjectRequestSuccess)success
                   failure:(ObjectRequestFailure)failure;

- (void)coefficientForEvent:(EventModel *)event
                       line:(LineModel *)line
                 components:(NSArray *)components
                    success:(ObjectRequestSuccess)success
                    failure:(ObjectRequestFailure)failure;

- (void)setStake:(StakeModel *)stake success:(Tag)success failure:(EmptyFailure)failure;

- (void)myStakesWithPaging:(PagingModel *)paging success:(Stakes)success failure:(EmptyFailure)failure;

- (void)stakesForEvent:(EventModel *)event
                paging:(PagingModel *)paging
               success:(Stakes)success
               failure:(EmptyFailure)failure;

#pragma mark - Tournaments

- (void)tournamentsForGroup:(NSString *)group
                     filter:(NSArray *)categoryTags
                     search:(NSString *)search
                      limit:(NSNumber *)limit
                       page:(NSNumber *)page
                    success:(ObjectRequestSuccess)success
                    failure:(ObjectRequestFailure)failure;

#pragma mark - Subscriptions

- (void)userSubscriptionsWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)userWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)registerWithUser:(UserModel *)user success:(AuthorizationUser)success failure:(EmptyFailure)failure;

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (NSNumber *)loginedUserTag;

@end
