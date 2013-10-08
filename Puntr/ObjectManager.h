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
    BetModel,
    CoefficientModel,
    CommentModel,
    CopyrightModel,
    CredentialsModel, 
    EventModel,
    FilterModel, 
    LineModel, 
    MoneyModel,
    PagingModel,
    ParticipantModel,
    PasswordModel,
    PrivacySettingsModel,
    PushSettingsModel,
    RegistrationModel,
    SearchModel,
    StakeModel,
    TournamentModel,
    UserModel;

typedef void (^EmptySuccess)();
typedef void (^EmptyFailure)();

typedef void (^Activities)(NSArray *activities);
typedef void (^AuthorizationUser)(AuthorizationModel *authorization, UserModel *user);
typedef void (^Awards)(NSArray *awards);
typedef void (^Categories)(NSArray *categories);
typedef void (^Coefficient)(CoefficientModel *coefficient);
typedef void (^Comments)(NSArray *comments);
typedef void (^Components)(NSArray *components);
typedef void (^Copyright)(CopyrightModel *copyright);
typedef void (^Events)(NSArray *events);
typedef void (^Groups)(NSArray *groups);
typedef void (^Lines)(NSArray *lines);
typedef void (^Money)(MoneyModel *money);
typedef void (^News)(NSArray *news);
typedef void (^Participants)(NSArray *participants);
typedef void (^Privacy)(NSArray *privacy);
typedef void (^Push)(NSArray *push);
typedef void (^Scores)(NSArray *scores);
typedef void (^Stake)(StakeModel *stake);
typedef void (^Stakes)(NSArray *stakes);
typedef void (^Subscribers)(NSArray *subscribers);
typedef void (^Subscriptions)(NSArray *subscriptions);
typedef void (^Tag)(NSNumber *tag);
typedef void (^Tournaments)(NSArray *tournaments);
typedef void (^User)(UserModel *user);
typedef void (^Users)(NSArray *users);

@interface ObjectManager : RKObjectManager

@property (nonatomic, strong) AuthorizationModel *authorization;

- (void)configureMapping;

#pragma mark - Authorization

- (BOOL)authorized;

- (void)clearAuthorization;

- (void)logInWithAccess:(AccessModel *)access success:(AuthorizationUser)success failure:(EmptyFailure)failure;

- (void)logOutWithSuccess:(EmptySuccess)success failure:(EmptyFailure)failure;

#pragma mark - Awards

- (void)awardsForUser:(UserModel *)user
               paging:(PagingModel *)paging
              success:(Subscriptions)success
              failure:(EmptyFailure)failure;

#pragma mark - Bets

- (void)betLinesForEvent:(EventModel *)event success:(Lines)success failure:(EmptyFailure)failure;
- (void)setBet:(BetModel *)bet success:(EmptySuccess)success failure:(EmptyFailure)failure;
- (void)acceptBet:(BetModel *)bet success:(EmptySuccess)success failure:(EmptyFailure)failure;

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

#pragma mark - Copyrights

- (void)termWithSuccess:(Copyright)success failure:(EmptyFailure)failure;

- (void)offerWithSuccess:(Copyright)success failure:(EmptyFailure)failure;

#pragma mark - Events

- (void)eventsWithPaging:(PagingModel *)paging
                  filter:(FilterModel *)filter
                  search:(SearchModel *)search
                 success:(Events)success
                 failure:(EmptyFailure)failure;

- (void)scoresForEvent:(EventModel *)event success:(Scores)success failure:(EmptyFailure)failure;

#pragma mark - Groups

- (void)groupsWithSuccess:(Groups)success failure:(EmptyFailure)failure;

#pragma mark - Participants

- (void)participantsWithPaging:(PagingModel *)paging
                        filter:(FilterModel *)filter
                        search:(SearchModel *)search
                       success:(Participants)success
                       failure:(EmptyFailure)failure;

- (void)eventsForParticipant:(ParticipantModel *)participant
                      paging:(PagingModel *)paging
                     success:(Events)success
                     failure:(EmptyFailure)failure;

#pragma mark - Stakes

- (void)stakeLinesForEvent:(EventModel *)event success:(Lines)success failure:(EmptyFailure)failure;

- (void)coefficientForEvent:(EventModel *)event
                       line:(LineModel *)line
                    success:(Coefficient)success
                    failure:(EmptyFailure)failure;

- (void)setStake:(StakeModel *)stake success:(Stake)success failure:(EmptyFailure)failure;

- (void)myStakesWithPaging:(PagingModel *)paging success:(Stakes)success failure:(EmptyFailure)failure;

- (void)stakesForEvent:(EventModel *)event
                paging:(PagingModel *)paging
               success:(Stakes)success
               failure:(EmptyFailure)failure;

#pragma mark - Subscribers

- (void)subscribersForUser:(UserModel *)user
                    paging:(PagingModel *)paging
                   success:(Subscribers)success
                   failure:(EmptyFailure)failure;

#pragma mark - Subscriptions

- (void)subscribeFor:(id <Parametrization>)object success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)unsubscribeFrom:(id <Parametrization>)object success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)subscriptionsForUser:(UserModel *)user
                      paging:(PagingModel *)paging
                     success:(Subscriptions)success
                     failure:(EmptyFailure)failure;

#pragma mark - Tournaments

- (void)tournamentsWithPaging:(PagingModel *)paging
                       filter:(FilterModel *)filter
                       search:(SearchModel *)search
                      success:(Tournaments)success
                      failure:(EmptyFailure)failure;

- (void)eventsForTournament:(TournamentModel *)tournament
                     paging:(PagingModel *)paging
                     filter:(FilterModel *)filter
                     search:(SearchModel *)search
                    success:(Events)success
                    failure:(EmptyFailure)failure;

#pragma mark - User

- (void)usersWithPaging:(PagingModel *)paging
                 search:(SearchModel *)search
                success:(Users)success
                failure:(EmptyFailure)failure;

- (void)profileWithSuccess:(User)success failure:(EmptyFailure)failure;

- (void)updateProfileWithUser:(UserModel *)user success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)changePassord:(PasswordModel *)password success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)userWithModel:(UserModel *)user success:(User)success failure:(EmptyFailure)failure;

- (void)registerWithUser:(UserModel *)user success:(AuthorizationUser)success failure:(EmptyFailure)failure;

- (void)newsWithPaging:(PagingModel *)paging success:(News)success failure:(EmptyFailure)failure;

- (void)activitiesForUser:(UserModel *)user
                   paging:(PagingModel *)paging
                  success:(Activities)success
                  failure:(EmptyFailure)failure;

- (void)balanceWithSuccess:(Money)success failure:(EmptyFailure)failure;

- (void)privacyWithSuccess:(Privacy)success failure:(EmptyFailure)failure;

- (void)setPrivacy:(PrivacySettingsModel *)privacy success:(Privacy)success failure:(EmptyFailure)failure;

- (void)setSocialsWithAccess:(AccessModel *)access success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)disconnectSocialsWithName:(NSString *)socialNetwork success:(EmptySuccess)success failure:(EmptyFailure)failure;

- (void)pushWithSuccess:(Push)success failure:(EmptyFailure)failure;

- (void)setPush:(PushSettingsModel *)push success:(Push)success failure:(EmptyFailure)failure;

- (UserModel *)loginedUser;

@end
