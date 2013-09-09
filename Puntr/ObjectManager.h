//
//  ObjectManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RKObjectManager.h"
#import "Parametrization.h"

@class
    AccessModel,
    AuthorizationModel,
    CoefficientModel,
    CommentModel,
    CredentialsModel, 
    EventModel,
    FilterModel, 
    LineModel, 
    MoneyModel,
    PagingModel,
    PasswordModel,
    PrivacySettingsModel,
    PushSettingsModel,
    RegistrationModel,
    StakeModel,
    TournamentModel,
    UserModel;

typedef void (^EmptySuccess)();
typedef void (^EmptyFailure)();

typedef void (^ObjectRequestSuccess)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^ObjectRequestFailure)(RKObjectRequestOperation *operation, NSError *error);

typedef void (^Activities)(NSArray *activities);
typedef void (^AuthorizationUser)(AuthorizationModel *authorization, UserModel *user);
typedef void (^Awards)(NSArray *awards);
typedef void (^Categories)(NSArray *categories);
typedef void (^Coefficient)(CoefficientModel *coefficient);
typedef void (^Comments)(NSArray *comments);
typedef void (^Components)(NSArray *components);
typedef void (^Events)(NSArray *events);
typedef void (^Groups)(NSArray *groups);
typedef void (^Money)(MoneyModel *money);
typedef void (^News)(NSArray *news);
typedef void (^Privacy)(NSArray *privacy);
typedef void (^Push)(NSArray *push);
typedef void (^Stake)(StakeModel *stake);
typedef void (^Stakes)(NSArray *stakes);
typedef void (^Subscribers)(NSArray *subscribers);
typedef void (^Subscriptions)(NSArray *subscriptions);
typedef void (^Tag)(NSNumber *tag);
typedef void (^Tournaments)(NSArray *tournaments);
typedef void (^User)(UserModel *user);

@interface ObjectManager : RKObjectManager

@property (nonatomic, strong) AuthorizationModel *authorization;

- (void)configureMapping;

#pragma mark - Authorization

- (void)logInWithAccess:(AccessModel *)access success:(AuthorizationUser)success failure:(EmptyFailure)failure;

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

- (void)setStake:(StakeModel *)stake success:(Stake)success failure:(EmptyFailure)failure;

- (void)myStakesWithPaging:(PagingModel *)paging success:(Stakes)success failure:(EmptyFailure)failure;

- (void)stakesForEvent:(EventModel *)event
                paging:(PagingModel *)paging
               success:(Stakes)success
               failure:(EmptyFailure)failure;

#pragma mark - Subscriptions

- (void)subscribeFor:(id <Parametrization>)object success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)unsubscribeFrom:(id <Parametrization>)object success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)subscriptionsForUser:(UserModel *)user
                      paging:(PagingModel *)paging
                     success:(Subscriptions)success
                     failure:(EmptyFailure)failure;

#pragma mark - Awards

- (void)awardsForUser:(UserModel *)user
               paging:(PagingModel *)paging
              success:(Subscriptions)success
              failure:(EmptyFailure)failure;

#pragma mark - Tournaments


- (void)tournamentsWithPaging:(PagingModel *)paging
                       filter:(FilterModel *)filter
                      success:(Tournaments)success
                      failure:(EmptyFailure)failure;

- (void)eventsForTournament:(TournamentModel *)tournament
                     paging:(PagingModel *)paging
                     filter:(FilterModel *)filter
                    success:(Events)success
                    failure:(EmptyFailure)failure;

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)updateProfileWithUser:(UserModel *)user success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)changePassord:(PasswordModel *)password success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)userWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)registerWithUser:(UserModel *)user success:(AuthorizationUser)success failure:(EmptyFailure)failure;

- (void)newsWithPaging:(PagingModel *)paging success:(News)success failure:(EmptyFailure)failure;

- (void)activitiesForUser:(UserModel *)user
                   paging:(PagingModel *)paging
                  success:(Activities)success
                  failure:(EmptyFailure)failure;

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)privacyWithSuccess:(Privacy)success failure:(EmptyFailure)failure;

- (void)setPrivacy:(PrivacySettingsModel *)privacy success:(Privacy)success failure:(EmptyFailure)failure;

- (void)setSocialsWithAccess:(AccessModel *)access success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)disconnectSocialsWithName:(NSString *)socialNetwork success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)pushWithSuccess:(Push)success failure:(EmptyFailure)failure;

- (void)setPush:(PushSettingsModel *)push success:(Push)success failure:(EmptyFailure)failure;

- (UserModel *)loginedUser;

@end
