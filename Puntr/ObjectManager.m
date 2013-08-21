//
//  ObjectManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "Models.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "RKObjectRequestOperation+HeaderFields.h"
#import "RKRelationshipMapping+Convenience.h"

@interface ObjectManager ()

@property (nonatomic, strong) AuthorizationModel *authorization;
@property (nonatomic, strong) UserModel *user;

@end

@implementation ObjectManager

- (id)initWithHTTPClient:(AFHTTPClient *)client
{
    self = [super initWithHTTPClient:client];
    
    if (self)
    {
        _authorization = [[AuthorizationModel alloc] init];
        _user = [[UserModel alloc] init];
        [self setRequestSerializationMIMEType:RKMIMETypeJSON];
        [self setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    }
    return self;
}

- (void)configureMapping
{
    // Status Codes
    
    NSIndexSet *statusCodeOK = [NSIndexSet indexSetWithIndex:200];
    NSIndexSet *statusCodeCreated = [NSIndexSet indexSetWithIndex:201];
    NSIndexSet *statusCodeNoContent = [NSIndexSet indexSetWithIndex:204];
    NSIndexSet *statusCodeNotModified = [NSIndexSet indexSetWithIndex:304];
    NSIndexSet *statusCodeBadRequest = [NSIndexSet indexSetWithIndex:400];
    NSIndexSet *statusCodeUnauthorized = [NSIndexSet indexSetWithIndex:401];
    NSIndexSet *statusCodeForbidden = [NSIndexSet indexSetWithIndex:403];
    NSIndexSet *statusCodeNotFound = [NSIndexSet indexSetWithIndex:404];
    NSIndexSet *statusCodeConflict = [NSIndexSet indexSetWithIndex:409];
    NSIndexSet *statusCodeUnprocessableEntity = [NSIndexSet indexSetWithIndex:422];
    NSIndexSet *statusCodeInternalServerError = [NSIndexSet indexSetWithIndex:500];
    NSIndexSet *statusCodeNotImplemented = [NSIndexSet indexSetWithIndex:501];
    
    // Mapping Declaration
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[ActivityModel class]];
    RKObjectMapping *authorizationMapping = [RKObjectMapping mappingForClass:[AuthorizationModel class]];
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    RKObjectMapping *coefficientMapping = [RKObjectMapping mappingForClass:[CoefficientModel class]];
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[CommentModel class]];
    RKObjectMapping *componentMapping = [RKObjectMapping mappingForClass:[ComponentModel class]];
    RKObjectMapping *criterionMapping = [RKObjectMapping mappingForClass:[CriterionModel class]];
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ErrorModel class]];
    RKObjectMapping *eventMapping = [RKObjectMapping mappingForClass:[EventModel class]];
    RKObjectMapping *feedMapping = [RKObjectMapping mappingForClass:[FeedModel class]];
    RKObjectMapping *groupMapping = [RKObjectMapping mappingForClass:[GroupModel class]];
    RKObjectMapping *lineMapping = [RKObjectMapping mappingForClass:[LineModel class]];
    RKObjectMapping *moneyMapping = [RKObjectMapping mappingForClass:[MoneyModel class]];
    RKObjectMapping *newsMapping = [RKObjectMapping mappingForClass:[NewsModel class]];
    RKObjectMapping *parameterMapping = [RKObjectMapping mappingForClass:[ParameterModel class]];
    RKObjectMapping *participantMapping = [RKObjectMapping mappingForClass:[ParticipantModel class]];
    RKObjectMapping *stakeMapping = [RKObjectMapping mappingForClass:[StakeModel class]];
    RKObjectMapping *subscriberMapping = [RKObjectMapping mappingForClass:[SubscriberModel class]];
    RKObjectMapping *subscriptionMapping = [RKObjectMapping mappingForClass:[SubscriptionModel class]];
    RKObjectMapping *tournamentMapping = [RKObjectMapping mappingForClass:[TournamentModel class]];
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[UserModel class]];
    
    // Mapping
    
    // Activity
    [activityMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt, KeyType]];
    RKRelationshipMapping *activityStakeRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyStake mapping:stakeMapping];
    RKRelationshipMapping *activityFeedRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyFeed mapping:feedMapping];
    [activityMapping addPropertyMappingsFromArray:@[activityStakeRelationship, activityFeedRelationship]];
    RKResponseDescriptor *activityResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:activityMapping
                                                                                               pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIActivities]
                                                                                                   keyPath:KeyActivities
                                                                                               statusCodes:statusCodeOK];
    
    // Authorization
    [authorizationMapping addAttributeMappingsFromArray:@[KeySID, KeySecret]];
    RKResponseDescriptor *authorizationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping
                                                                                                    pathPattern:APIAuthorization
                                                                                                        keyPath:KeyAuthorization
                                                                                                    statusCodes:statusCodeCreated];
    RKResponseDescriptor *authorizationUserCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping
                                                                                                              pathPattern:APIUsers
                                                                                                                  keyPath:KeyAuthorization
                                                                                                              statusCodes:statusCodeCreated];
    
    // Category
    [categoryMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    RKResponseDescriptor *categoryCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping
                                                                                                         pathPattern:APICategories
                                                                                                             keyPath:KeyCategories
                                                                                                         statusCodes:statusCodeOK];
    
    // Coefficient
    [coefficientMapping addAttributeMappingsFromArray:@[KeyValue]];
    RKResponseDescriptor *coefficientResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coefficientMapping
                                                                                                  pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APICoefficient]
                                                                                                      keyPath:KeyCoefficient
                                                                                                  statusCodes:statusCodeOK];
    
    // Comment
    [commentMapping addAttributeMappingsFromArray:@[KeyMessage, KeyCreatedAt]];
    RKRelationshipMapping *commentUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    RKRelationshipMapping *commentEventRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyEvent mapping:eventMapping];
    [commentMapping addPropertyMappingsFromArray:@[commentUserRelationship, commentEventRelationship]];
    RKResponseDescriptor *commentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                              pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComments]
                                                                                                  keyPath:KeyActivities
                                                                                              statusCodes:statusCodeOK];
    
    // Component
    [componentMapping addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    RKRelationshipMapping *componentCriterionRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyCriteria mapping:criterionMapping];
    [componentMapping addPropertyMapping:componentCriterionRelationship];
    RKResponseDescriptor *componentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:componentMapping
                                                                                                          pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComponents]
                                                                                                              keyPath:KeyComponents
                                                                                                          statusCodes:statusCodeOK];
    
    // Criterion
    [criterionMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Error
    [errorMapping addAttributeMappingsFromArray:@[KeyMessage, KeyCode]];
    RKRelationshipMapping *errorParameterRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyParameters mapping:parameterMapping];
    [errorMapping addPropertyMapping:errorParameterRelationship];
    NSMutableIndexSet *errorStatusCodes = [NSMutableIndexSet indexSet];
    [errorStatusCodes addIndexes:statusCodeNotModified];
    [errorStatusCodes addIndexes:statusCodeBadRequest];
    [errorStatusCodes addIndexes:statusCodeUnauthorized];
    [errorStatusCodes addIndexes:statusCodeForbidden];
    [errorStatusCodes addIndexes:statusCodeNotFound];
    [errorStatusCodes addIndexes:statusCodeConflict];
    [errorStatusCodes addIndexes:statusCodeUnprocessableEntity];
    [errorStatusCodes addIndexes:statusCodeInternalServerError];
    [errorStatusCodes addIndexes:statusCodeNotImplemented];
    RKResponseDescriptor *errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                            pathPattern:nil
                                                                                                keyPath:nil
                                                                                            statusCodes:errorStatusCodes];
    
    // Event
    [eventMapping addAttributeMappingsFromArray:@[KeyTag, KeyStakesCount, KeySubscribersCount, KeyCreatedAt, KeyStartTime, KeyEndTime, KeyStatus, KeyBanner, KeySubscribed]];
    RKRelationshipMapping *eventTournamentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyTournament mapping:tournamentMapping];
    RKRelationshipMapping *eventParticipantRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyParticipants mapping:participantMapping];
    RKRelationshipMapping *eventLineRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyLines mapping:lineMapping];
    [eventMapping addPropertyMappingsFromArray:@[eventTournamentRelationship, eventParticipantRelationship, eventLineRelationship]];
    RKResponseDescriptor *eventCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping
                                                                                                    pathPattern:APIEvents
                                                                                                          keyPath:KeyEvents
                                                                                                      statusCodes:statusCodeOK];
    
    // Feed
    [feedMapping addAttributeMappingsFromArray:@[KeyMessage]];
    RKRelationshipMapping *feedUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    [feedMapping addPropertyMapping:feedUserRelationship];
    
    // Group
    [groupMapping addAttributeMappingsFromArray:@[KeyTitle, KeyImage, KeySlug]];
    RKResponseDescriptor *groupCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:groupMapping
                                                                                                      pathPattern:APIGroups
                                                                                                          keyPath:KeyGroups
                                                                                                      statusCodes:statusCodeOK];
    
    // Line
    [lineMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Money
    [moneyMapping addAttributeMappingsFromArray:@[KeyAmount]];
    RKResponseDescriptor *moneyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:moneyMapping
                                                                                            pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIBalance]
                                                                                                keyPath:KeyBalance
                                                                                            statusCodes:statusCodeOK];

    // News
    [newsMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt]];
    RKRelationshipMapping *newsStakeRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyStake mapping:stakeMapping];
    RKRelationshipMapping *newsCommentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyComment mapping:commentMapping];
    RKRelationshipMapping *newsFeedRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyFeed mapping:feedMapping];
    [newsMapping addPropertyMappingsFromArray:@[newsStakeRelationship, newsCommentRelationship, newsFeedRelationship]];
    RKResponseDescriptor *newsCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APINews] keyPath:KeyNews statusCodes:statusCodeOK];
    
    // Parameter
    [parameterMapping addAttributeMappingsFromArray:@[KeyKey, KeyDescription]];
    
    // Participant
    [participantMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyLogo, KeySubscribersCount, KeySubscribed]];
    
    // Stake
    [stakeMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt, KeyStatus]];
    RKRelationshipMapping *stakeUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    RKRelationshipMapping *stakeEventRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyEvent mapping:eventMapping];
    RKRelationshipMapping *stakeLineRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyLine mapping:lineMapping];
    RKRelationshipMapping *stakeComponentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyComponents mapping:componentMapping];
    RKRelationshipMapping *stakeCoefficientRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyCoefficient mapping:coefficientMapping];
    RKRelationshipMapping *stakeMoneyRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyMoney mapping:moneyMapping];
    [stakeMapping addPropertyMappingsFromArray:@[stakeUserRelationship, stakeEventRelationship, stakeLineRelationship, stakeComponentRelationship, stakeCoefficientRelationship, stakeMoneyRelationship]];
    RKResponseDescriptor *stakeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping
                                                                                            pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIStakes]
                                                                                                keyPath:KeyStake
                                                                                            statusCodes:statusCodeCreated];
    RKResponseDescriptor *stakeEventsCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping
                                                                                                            pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIStakes]
                                                                                                                keyPath:KeyStakes
                                                                                                            statusCodes:statusCodeOK];
    RKResponseDescriptor *stakeUsersCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping
                                                                                                           pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIStakes]
                                                                                                               keyPath:KeyStakes
                                                                                                           statusCodes:statusCodeOK];
    
    // Subscriber
    RKRelationshipMapping *subscriberUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    [subscriberMapping addPropertyMapping:subscriberUserRelationship];
    RKResponseDescriptor *subscriberCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:subscriberMapping
                                                                                                           pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APISubscribers]
                                                                                                               keyPath:KeySubscribers
                                                                                                           statusCodes:statusCodeOK];
    
    // Subscription
    RKRelationshipMapping *subscriptionEventRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyEvent mapping:eventMapping];
    RKRelationshipMapping *subscriptionParticipantRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyParticipant mapping:participantMapping];
    RKRelationshipMapping *subscriptionTournamentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyTournament mapping:tournamentMapping];
    RKRelationshipMapping *subscriptionUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    [subscriptionMapping addPropertyMappingsFromArray:@[subscriptionEventRelationship, subscriptionParticipantRelationship, subscriptionTournamentRelationship, subscriptionUserRelationship]];
    RKResponseDescriptor *subscriptionCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:subscriptionMapping
                                                                                                             pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APISubscriptions]
                                                                                                                 keyPath:KeySubscriptions
                                                                                                             statusCodes:statusCodeOK];
    RKResponseDescriptor *subscriptionCreateAndDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:subscriptionMapping
                                                                                                         pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APISubscriptions]
                                                                                                             keyPath:nil
                                                                                                         statusCodes:statusCodeNoContent];
    
    // Tournament
    [tournamentMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyBanner, KeyStakesCount, KeySubscribersCount, KeyStartTime, KeyEndTime, KeySubscribed]];
    RKRelationshipMapping *tournamentCategoryRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyCategory mapping:categoryMapping];
    [tournamentMapping addPropertyMapping:tournamentCategoryRelationship];
    RKResponseDescriptor *tournamentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tournamentMapping
                                                                                                           pathPattern:APITournaments
                                                                                                               keyPath:KeyTournaments
                                                                                                           statusCodes:statusCodeOK];
    
    // User
    [userMapping addAttributeMappingsFromArray:@[KeyTag, KeyEmail, KeyFirstName, KeyLastName, KeyUsername, KeyAvatar, KeySubscribed, KeyTopPosition, KeyRating, KeySubscriptionsCount, KeySubscribersCount, KeyBadgesCount, KeyWinCount, KeyLossCount]];
    RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                           pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers]
                                                                                               keyPath:KeyUser
                                                                                           statusCodes:statusCodeOK];
    RKResponseDescriptor *userCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                 pathPattern:APIUsers
                                                                                                     keyPath:KeyUser
                                                                                                 statusCodes:statusCodeCreated];
    RKResponseDescriptor *userAuthorizationCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                              pathPattern:APIAuthorization
                                                                                                                  keyPath:KeyUser
                                                                                                              statusCodes:statusCodeCreated];
    
    // Response Descriptors
    [self addResponseDescriptorsFromArray:
        @[
            activityResponseDescriptor,
            authorizationResponseDescriptor,
            authorizationUserCreateResponseDescriptor,
            categoryCollectionResponseDescriptor,
            coefficientResponseDescriptor,
            commentResponseDescriptor,
            componentCollectionResponseDescriptor,
            errorResponseDescriptor,
            eventCollectionResponseDescriptor,
            groupCollectionResponseDescriptor,
            moneyResponseDescriptor,
            newsCollectionResponseDescriptor,
            stakeEventsCollectionResponseDescriptor,
            stakeResponseDescriptor,
            stakeUsersCollectionResponseDescriptor,
            subscriberCollectionResponseDescriptor,
            subscriptionCollectionResponseDescriptor,
            subscriptionCreateAndDeleteResponseDescriptor,
            tournamentCollectionResponseDescriptor,
            userAuthorizationCreateResponseDescriptor,
            userCreateResponseDescriptor,
            userResponseDescriptor
         ]
    ];
    
    // Serialization
    
    // Comment
    RKObjectMapping *commentSerialization = [RKObjectMapping requestMapping];
    [commentSerialization addAttributeMappingsFromArray:@[KeyMessage]];
    RKRequestDescriptor *commentRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:commentSerialization
                                                                                          objectClass:[CommentModel class]
                                                                                          rootKeyPath:nil];
    
    // Credentials
    RKObjectMapping *credentialsSerialization = [RKObjectMapping requestMapping];
    [credentialsSerialization addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *credentialsRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:credentialsSerialization
                                                                                              objectClass:[CredentialsModel class]
                                                                                              rootKeyPath:KeyCredentials];
    
    // Facebook
    RKObjectMapping *facebookSerialization = [RKObjectMapping requestMapping];
    [facebookSerialization addAttributeMappingsFromArray:@[KeyTag, KeyAccessToken]];
    RKRequestDescriptor *facebookRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:facebookSerialization
                                                                                            objectClass:[FacebookModel class]
                                                                                            rootKeyPath:KeyFacebook];
    // Participant
    RKObjectMapping *participantSerialization = [RKObjectMapping requestMapping];
    [participantSerialization addAttributeMappingsFromArray:@[KeyTag]];
    RKRequestDescriptor *participantRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:participantSerialization
                                                                                              objectClass:[ParticipantModel class]
                                                                                              rootKeyPath:KeyParticipant];
    
    // Stake
    RKObjectMapping *stakeSerialization = [RKObjectMapping requestMapping];
    [stakeSerialization addPropertyMappingsFromArray:@[
     [stakeLineRelationship copy],
     [stakeComponentRelationship copy],
     [stakeCoefficientRelationship copy],
     [stakeMoneyRelationship copy]]];
    RKRequestDescriptor *stakeRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[stakeMapping inverseMapping]
                                                                                        objectClass:[StakeModel class]
                                                                                        rootKeyPath:nil];
    
    // Tournament
    RKObjectMapping *tournamentSerialization = [RKObjectMapping requestMapping];
    [tournamentSerialization addAttributeMappingsFromArray:@[KeyTag]];
    RKRequestDescriptor *tournamentRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:tournamentSerialization
                                                                                             objectClass:[TournamentModel class]
                                                                                             rootKeyPath:KeyTournament];
    
    // Twitter
    RKObjectMapping *twitterSerialization = [RKObjectMapping requestMapping];
    [twitterSerialization addAttributeMappingsFromArray:@[KeyTag, KeyAccessToken, KeySecretToken]];
    RKRequestDescriptor *twitterRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:twitterSerialization
                                                                                          objectClass:[TwitterModel class]
                                                                                          rootKeyPath:KeyTwitter];
    
    // User
    RKObjectMapping *userSerialization = [RKObjectMapping requestMapping];
    [userSerialization addAttributeMappingsFromArray:@[KeyTag, KeyEmail, KeyPassword, KeyFirstName, KeyLastName, KeyUsername]];
    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userSerialization
                                                                                       objectClass:[UserModel class]
                                                                                       rootKeyPath:nil];
    
    // VKontakte
    RKObjectMapping *vKontakteSerialization = [RKObjectMapping requestMapping];
    [vKontakteSerialization addAttributeMappingsFromArray:@[KeyTag, KeyAccessToken]];
    RKRequestDescriptor *vKontakteRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:vKontakteSerialization
                                                                                            objectClass:[VKontakteModel class]
                                                                                            rootKeyPath:KeyVKontakte];
    
    [self addRequestDescriptorsFromArray:
        @[
            commentRequestDescriptor,
            credentialsRequestDescriptor,
            facebookRequestDescriptor,
            participantRequestDescriptor,
            stakeRequestDescriptor,
            tournamentRequestDescriptor,
            twitterRequestDescriptor,
            userRequestDescriptor,
            vKontakteRequestDescriptor
         ]
    ];
}

#pragma mark - Authorization

- (void)logInWithAccess:(AccessModel *)access success:(AuthorizationUser)success failure:(EmptyFailure)failure
{
    [self postObject:access
                path:APIAuthorization
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
             {
                 NSDictionary *response = mappingResult.dictionary;
                 AuthorizationModel *authorization = (AuthorizationModel *)response[KeyAuthorization];
                 UserModel *user = (UserModel *)response[KeyUser];
                 self.authorization = authorization;
                 self.user = user;
                 success(authorization, user);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error)
             {
                 [self reportWithFailure:failure error:error];
             }
    ];
}

- (void)logOutWithSuccess:(EmptySuccess)success failure:(EmptyFailure)failure
{
    [self.HTTPClient deletePath:APIAuthorization
                     parameters:self.authorization.wrappedParameters
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                        {
                            success();
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error)
                        {
                            [self reportWithFailure:failure error:error];
                        }
    ];
}

#pragma mark - Categories

- (void)categoriesWithSuccess:(Categories)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:APICategories
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *categories = mappingResult.dictionary[KeyCategories];
                success(categories);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

#pragma mark - Comments

- (void)commentsForEvent:(EventModel *)event
                  paging:(PagingModel *)paging
                 success:(Comments)success
                 failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIComments]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *comments = mappingResult.dictionary[KeyComments];
                success(comments);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
     ];
}

- (void)postComment:(CommentModel *)comment
           forEvent:(EventModel *)event
            success:(EmptySuccess)success
            failure:(EmptyFailure)failure
{
    [self postObject:comment
                path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIComments]
          parameters:self.authorization.wrappedParameters
             success:success
             failure:^(RKObjectRequestOperation *operation, NSError *error)
             {
                 [self reportWithFailure:failure error:error];
             }
     ];
}

#pragma mark - Events

- (void)eventsWithPaging:(PagingModel *)paging
                  filter:(FilterModel *)filter
                 success:(Events)success
                 failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null],
                                     KeyFilter: filter ? filter.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:APIEvents
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *events = mappingResult.dictionary[KeyEvents];
                success(events);
            } failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

#pragma mark - Events Compatibility

- (void)eventsWithFilter:(FilterModel *)filter
                paging:(PagingModel *)paging
                 success:(Events)success
                 failure:(EmptyFailure)failure
{
    
}

- (void)eventsForGroup:(NSString *)group
                 limit:(NSNumber *)limit
               success:(ObjectRequestSuccess)success
               failure:(ObjectRequestFailure)failure
{
    [self eventsForGroup:group
                  filter:nil
                  search:nil
                   limit:limit
                    page:nil
                 success:success
                 failure:failure];
}

- (void)eventsForGroup:(NSString *)group
                filter:(NSArray *)categoryTags
                search:(NSString *)search
                 limit:(NSNumber *)limit
                  page:(NSNumber *)page
               success:(ObjectRequestSuccess)success
               failure:(ObjectRequestFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.authorization.wrappedParameters];
    if (group)
    {
        [parameters setObject:group forKey:KeyGroup];
    }
    if (categoryTags && categoryTags.count != 0 && ![categoryTags[0] isEqualToNumber:@0])
    {
        [parameters setObject:categoryTags forKey:KeyFilter];
    }
    if (search)
    {
        [parameters setObject:search forKey:KeySearch];
    }
    if (limit)
    {
        [parameters setObject:limit forKey:KeyLimit];
    }
    if (page && limit)
    {
        [parameters setObject:@(page.integerValue * limit.integerValue) forKey:KeyOffset];
    }
    
    [self getObject:nil
               path:APIEvents
         parameters:parameters
            success:success
            failure:failure];
}

#pragma mark - Groups

- (void)groupsWithSuccess:(Groups)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:APIGroups
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *groups = mappingResult.dictionary[KeyGroups];
                success(groups);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

#pragma mark - Stakes

- (void)componentsForEvent:(EventModel *)event
                      line:(LineModel *)line
                   success:(ObjectRequestSuccess)success
                   failure:(ObjectRequestFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIComponents]
         parameters:@{ KeyAuthorization: self.authorization.parameters, KeyLine: @{ KeyTag: line.tag } }
            success:success
            failure:failure];
}

- (void)coefficientForEvent:(EventModel *)event
                       line:(LineModel *)line
                 components:(NSArray *)components
                    success:(ObjectRequestSuccess)success
                    failure:(ObjectRequestFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{ KeyAuthorization: self.authorization.parameters, KeyLine: @{ KeyTag: line.tag } }];
    NSMutableArray *componentsParamenters = [NSMutableArray arrayWithCapacity:components.count];
    for (ComponentModel *component in components)
    {
        [componentsParamenters addObject:@{ KeyPosition: component.position, KeySelectedCriterion: component.selectedCriterion }];
    }
    [parameters setObject:[componentsParamenters copy] forKey:KeyComponents];
    
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APICoefficient]
         parameters:[parameters copy]
            success:success
            failure:failure];
}

- (void)setStake:(StakeModel *)stake success:(Stake)success failure:(EmptyFailure)failure
{
    EventModel *event = stake.event;
    [stake prepareForTransmission];
    [self postObject:stake
                path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIStakes]
          parameters:self.authorization.wrappedParameters
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
             {
                 [NotificationManager showSuccessMessage:@"Ура! Ставка сделана!"];
                 success(mappingResult.firstObject);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error)
             {
                 [self reportWithFailure:failure error:error];
             }
    ];
}

- (void)myStakesWithPaging:(PagingModel *)paging success:(Stakes)success failure:(EmptyFailure)failure
{
    [self stakesForEvent:nil paging:paging success:success failure:failure];
}

- (void)stakesForEvent:(EventModel *)event
                paging:(PagingModel *)paging
               success:(Stakes)success
               failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                    KeyAuthorization: self.authorization.parameters,
                                    KeyPaging: paging ? paging.parameters : [NSNull null]
                                };
   
    NSString *api = event ? APIEvents : APIUsers;
    NSNumber *tag = event ? event.tag : self.user.tag;
    
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", api, tag.stringValue, APIStakes]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *stakes = mappingResult.dictionary[KeyStakes];
                success(stakes);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

#pragma mark - Subscriptions

- (void)subscribeFor:(NSObject *)object success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    [self postObject:object
                path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APISubscriptions]
          parameters:self.authorization.wrappedParameters
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
             {
                 success();
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error)
             {
                 [self reportWithFailure:failure error:error];
             }
    ];
}

- (void)unsubscribeFrom:(NSObject *)object success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    [self deleteObject:object
                  path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APISubscriptions]
            parameters:self.authorization.wrappedParameters
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
               {
                   success();
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error)
               {
                   [self reportWithFailure:failure error:error];
               }
    ];
}

#pragma mark - Tournaments

- (void)tournamentssForGroup:(NSString *)group
                       limit:(NSNumber *)limit
                     success:(ObjectRequestSuccess)success
                     failure:(ObjectRequestFailure)failure
{
    [self tournamentsForGroup:group
                    filter:nil
                       search:nil
                        limit:limit
                         page:nil
                      success:success
                      failure:failure];
}

- (void)tournamentsForGroup:(NSString *)group
                     filter:(NSArray *)categoryTags
                     search:(NSString *)search
                      limit:(NSNumber *)limit
                    page:(NSNumber *)page
                    success:(ObjectRequestSuccess)success
                    failure:(ObjectRequestFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.authorization.wrappedParameters];
    if (group)
    {
        [parameters setObject:group forKey:KeyGroup];
    }
    if (categoryTags && categoryTags.count != 0 && ![categoryTags[0] isEqualToNumber:@0])
    {
        [parameters setObject:categoryTags forKey:KeyFilter];
    }
    if (search)
    {
        [parameters setObject:search forKey:KeySearch];
    }
    if (limit)
    {
        [parameters setObject:limit forKey:KeyLimit];
    }
    if (page && limit)
    {
        [parameters setObject:@(page.integerValue * limit.integerValue) forKey:KeyOffset];
    }
    
    [self getObject:nil
               path:APITournaments
         parameters:parameters
            success:success
            failure:failure];
}

#pragma mark - Subscriptions

- (void)userSubscriptionsWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, userTag.stringValue, APISubscriptions]
         parameters:self.authorization.wrappedParameters
            success:success
            failure:failure];
}

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@", APIUsers, self.user.tag.stringValue]
         parameters:self.authorization.wrappedParameters
            success:success
            failure:failure];
}

- (void)updateProfileWithUser:(UserModel *)user success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    NSData *avatarData = UIImagePNGRepresentation(user.avatarData);
    user.avatarData = nil;
    NSMutableURLRequest *request = [self multipartFormRequestWithObject:user
                                                                 method:RKRequestMethodPUT
                                                                   path:[NSString stringWithFormat:@"%@/%@", APIUsers, self.user.tag.stringValue]
                                                             parameters:self.authorization.wrappedParameters
                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        if (avatarData)
                                        {
                                            [formData appendPartWithFileData:avatarData
                                                                        name:KeyAvatar
                                                                    fileName:@"avatar.png"
                                                                    mimeType:@"image/png"];
                                        }
                                    }
                                    ];
    
    RKObjectRequestOperation *operation = [self objectRequestOperationWithRequest:request success:success
                                                                          failure:^(RKObjectRequestOperation *operation, NSError *error)
                                           {
                                               [self reportWithFailure:failure error:error];                                                                   
                                           }
                                           ];
    [self enqueueObjectRequestOperation:operation];
}

- (void)userWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@", APIUsers, userTag.stringValue]
         parameters:self.authorization.wrappedParameters
            success:success
            failure:failure];
}

- (void)registerWithUser:(UserModel *)user success:(AuthorizationUser)success failure:(EmptyFailure)failure
{
    NSData *avatarData = UIImagePNGRepresentation(user.avatarData);
    user.avatarData = nil;
    NSMutableURLRequest *request = [self multipartFormRequestWithObject:user
                                                                 method:RKRequestMethodPOST
                                                                   path:APIUsers
                                                             parameters:nil
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
            if (avatarData)
            {
                [formData appendPartWithFileData:avatarData
                                            name:KeyAvatar
                                        fileName:@"avatar.png"
                                        mimeType:@"image/png"];
            }
        }
    ];
    
    RKObjectRequestOperation *operation = [self objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
        {
            NSDictionary *response = mappingResult.dictionary;
            AuthorizationModel *authorization = (AuthorizationModel *)response[KeyAuthorization];
            UserModel *user = (UserModel *)response[KeyUser];
            self.authorization = authorization;
            self.user = user;
            success(authorization, user);
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error)
        {
            [self reportWithFailure:failure error:error];                                                                   
        }
    ];
    [self enqueueObjectRequestOperation:operation];
}

- (void)newsWithPaging:(PagingModel *)paging success:(News)success failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                 KeyAuthorization: self.authorization.parameters,
                                 KeyPaging: paging ? paging.parameters : [NSNull null]
                                 };
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APINews]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *news = mappingResult.array;
                success(news);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)activitiesForUser:(UserModel *)user
                   paging:(PagingModel *)paging
                  success:(Activities)success
                  failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                 KeyAuthorization: self.authorization.parameters,
                                 KeyPaging: paging ? paging.parameters : [NSNull null]
                                 };
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, user.tag.stringValue, APIActivities]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *activities = mappingResult.array;
                success(activities);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIBalance]
         parameters:self.authorization.wrappedParameters
            success:success
            failure:failure];
}

- (UserModel *)loginedUser
{
    return self.user;
}

#pragma mark - Helpers

- (void)reportWithFailure:(EmptyFailure)failure error:(NSError *)error
{
    [NotificationManager showError:error];
    if (failure)
    {
        failure();
    }
}

@end