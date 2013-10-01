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
#import "RKRelationshipMapping+Convenience.h"

@interface ObjectManager ()

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) NSArray *categories;

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
    RKObjectMapping *awardMapping = [RKObjectMapping mappingForClass:[AwardModel class]];
    RKObjectMapping *authorizationMapping = [RKObjectMapping mappingForClass:[AuthorizationModel class]];
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    RKObjectMapping *coefficientMapping = [RKObjectMapping mappingForClass:[CoefficientModel class]];
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[CommentModel class]];
    RKObjectMapping *componentMapping = [RKObjectMapping mappingForClass:[ComponentModel class]];
    RKObjectMapping *copyrightMaping = [RKObjectMapping mappingForClass:[CopyrightModel class]];
    RKObjectMapping *criterionMapping = [RKObjectMapping mappingForClass:[CriterionModel class]];
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ErrorModel class]];
    RKObjectMapping *eventMapping = [RKObjectMapping mappingForClass:[EventModel class]];
    RKObjectMapping *groupMapping = [RKObjectMapping mappingForClass:[GroupModel class]];
    RKObjectMapping *lineMapping = [RKObjectMapping mappingForClass:[LineModel class]];
    RKObjectMapping *moneyMapping = [RKObjectMapping mappingForClass:[MoneyModel class]];
    RKObjectMapping *newsMapping = [RKObjectMapping mappingForClass:[NewsModel class]];
    RKObjectMapping *parameterMapping = [RKObjectMapping mappingForClass:[ParameterModel class]];
    RKObjectMapping *participantMapping = [RKObjectMapping mappingForClass:[ParticipantModel class]];
    RKObjectMapping *privacyMapping = [RKObjectMapping mappingForClass:[PrivacySettingsModel class]];
    RKObjectMapping *pushMapping = [RKObjectMapping mappingForClass:[PushSettingsModel class]];
    RKObjectMapping *socialsMaping = [RKObjectMapping mappingForClass:[SocialModel class]];
    RKObjectMapping *stakeMapping = [RKObjectMapping mappingForClass:[StakeModel class]];
    RKObjectMapping *statisticsMaping = [RKObjectMapping mappingForClass:[StatisticModel class]];
    RKObjectMapping *subscriberMapping = [RKObjectMapping mappingForClass:[SubscriberModel class]];
    RKObjectMapping *subscriptionMapping = [RKObjectMapping mappingForClass:[SubscriptionModel class]];
    RKObjectMapping *tournamentMapping = [RKObjectMapping mappingForClass:[TournamentModel class]];
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[UserModel class]];
    RKObjectMapping *userSocialMapping = [RKObjectMapping mappingForClass:[UserSocialModel class]];
    
    // Mapping
    
    // Activity
    [activityMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt, KeyType]];
    RKRelationshipMapping *activityStakeRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyStake mapping:stakeMapping];
    RKRelationshipMapping *activityCommentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyComment mapping:commentMapping];
    RKRelationshipMapping *activityEventRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyEvent mapping:eventMapping];
    RKRelationshipMapping *activityParticipantRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyParticipant mapping:participantMapping];
    RKRelationshipMapping *activityTournamentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyTournament mapping:tournamentMapping];
    RKRelationshipMapping *activityUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    [activityMapping addPropertyMappingsFromArray:@[
                                                       activityStakeRelationship,
                                                       activityCommentRelationship,
                                                       activityEventRelationship,
                                                       activityParticipantRelationship,
                                                       activityTournamentRelationship,
                                                       activityUserRelationship
                                                   ]];
    RKResponseDescriptor *activityResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:activityMapping
                                                                                                    method:RKRequestMethodGET
                                                                                               pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIActivities]
                                                                                                   keyPath:KeyActivities
                                                                                               statusCodes:statusCodeOK];
    
    // Authorization
    [authorizationMapping addAttributeMappingsFromArray:@[KeySID, KeySecret, KeyPushToken]];
    RKResponseDescriptor *authorizationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping
                                                                                                         method:RKRequestMethodPOST
                                                                                                    pathPattern:APIAuthorization
                                                                                                        keyPath:KeyAuthorization
                                                                                                    statusCodes:statusCodeCreated];
    RKResponseDescriptor *authorizationUserCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping
                                                                                                                   method:RKRequestMethodPOST
                                                                                                              pathPattern:APIUsers
                                                                                                                  keyPath:KeyAuthorization
                                                                                                              statusCodes:statusCodeCreated];
    
    // Award
    [awardMapping addAttributeMappingsFromArray:@[KeyTitle, KeyDescription, KeyImage, KeyReceived]];
    RKResponseDescriptor *awardCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:awardMapping
                                                                                                           method:RKRequestMethodGET
                                                                                                      pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIAwards]
                                                                                                          keyPath:KeyAwards
                                                                                                      statusCodes:statusCodeOK];
    
    // Category
    [categoryMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    RKResponseDescriptor *categoryCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping
                                                                                                              method:RKRequestMethodGET
                                                                                                         pathPattern:APICategories
                                                                                                             keyPath:KeyCategories
                                                                                                         statusCodes:statusCodeOK];
    
    // Coefficient
    [coefficientMapping addAttributeMappingsFromArray:@[KeyValue]];
    RKResponseDescriptor *coefficientResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coefficientMapping
                                                                                                       method:RKRequestMethodGET
                                                                                                  pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APICoefficient]
                                                                                                      keyPath:KeyCoefficient
                                                                                                  statusCodes:statusCodeOK];
    
    // Comment
    [commentMapping addAttributeMappingsFromArray:@[KeyMessage, KeyCreatedAt]];
    RKRelationshipMapping *commentUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    RKRelationshipMapping *commentEventRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyEvent mapping:eventMapping];
    [commentMapping addPropertyMappingsFromArray:@[commentUserRelationship, commentEventRelationship]];
    RKResponseDescriptor *commentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComments]
                                                                                                  keyPath:KeyComments
                                                                                              statusCodes:statusCodeOK];
    RKResponseDescriptor *commentCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                                         method:RKRequestMethodPOST
                                                                                                    pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComments]
                                                                                                        keyPath:nil
                                                                                                    statusCodes:statusCodeNoContent];
    
    // Component
    [componentMapping addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    RKRelationshipMapping *componentCriterionRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyCriteria mapping:criterionMapping];
    [componentMapping addPropertyMapping:componentCriterionRelationship];
    RKResponseDescriptor *componentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:componentMapping
                                                                                                               method:RKRequestMethodGET
                                                                                                          pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComponents]
                                                                                                              keyPath:KeyComponents
                                                                                                          statusCodes:statusCodeOK];
    
    //Copyright
    [copyrightMaping addAttributeMappingsFromArray:@[KeyOffer, KeyTerms]];
    RKResponseDescriptor *copyrightResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:copyrightMaping
                                                                                                     method:RKRequestMethodGET
                                                                                                pathPattern:[NSString stringWithFormat:@"%@/:field", APICopyright]
                                                                                                    keyPath:KeyCopyright
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
                                                                                                 method:RKRequestMethodAny
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
                                                                                                           method:RKRequestMethodGET
                                                                                                    pathPattern:APIEvents
                                                                                                          keyPath:KeyEvents
                                                                                                      statusCodes:statusCodeOK];
    RKResponseDescriptor *eventParticipantResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping
                                                                                                            method:RKRequestMethodGET
                                                                                                       pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIParticipants, APIEvents]
                                                                                                           keyPath:KeyEvents
                                                                                                       statusCodes:statusCodeOK];
    RKResponseDescriptor *eventTournamentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping
                                                                                                                     method:RKRequestMethodGET
                                                                                                                pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APITournaments, APIEvents]
                                                                                                                    keyPath:KeyEvents
                                                                                                                statusCodes:statusCodeOK];
    
    // Group
    [groupMapping addAttributeMappingsFromArray:@[KeyTitle, KeyImage, KeySlug]];
    RKResponseDescriptor *groupCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:groupMapping
                                                                                                           method:RKRequestMethodGET
                                                                                                      pathPattern:APIGroups
                                                                                                          keyPath:KeyGroups
                                                                                                      statusCodes:statusCodeOK];
    
    // Line
    [lineMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Money
    [moneyMapping addAttributeMappingsFromArray:@[KeyAmount]];
    RKResponseDescriptor *moneyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:moneyMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIBalance]
                                                                                                keyPath:KeyBalance
                                                                                            statusCodes:statusCodeOK];

    // News
    [newsMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt, KeyType]];
    RKRelationshipMapping *newsSubscriptionRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeySubscription mapping:subscriptionMapping];
    RKRelationshipMapping *newsStakeRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyStake mapping:stakeMapping];
    RKRelationshipMapping *newsCommentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyComment mapping:commentMapping];
    RKRelationshipMapping *newsEventRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyEvent mapping:eventMapping];
    RKRelationshipMapping *newsParticipantRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyParticipant mapping:participantMapping];
    RKRelationshipMapping *newsTournamentRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyTournament mapping:tournamentMapping];
    RKRelationshipMapping *newsUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    [newsMapping addPropertyMappingsFromArray:@[
                                                   newsSubscriptionRelationship,
                                                   newsStakeRelationship,
                                                   newsCommentRelationship,
                                                   newsEventRelationship,
                                                   newsParticipantRelationship,
                                                   newsTournamentRelationship,
                                                   newsUserRelationship
                                               ]];
    RKResponseDescriptor *newsCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsMapping
                                                                                                          method:RKRequestMethodGET
                                                                                                     pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APINews]
                                                                                                         keyPath:KeyNews
                                                                                                     statusCodes:statusCodeOK];
    
    // Parameter
    [parameterMapping addAttributeMappingsFromArray:@[KeyKey, KeyDescription]];
    
    // Participant
    [participantMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyLogo, KeySubscribersCount, KeySubscribed]];
    RKResponseDescriptor *participantCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:participantMapping
                                                                                                                 method:RKRequestMethodGET
                                                                                                            pathPattern:APIParticipants
                                                                                                                keyPath:KeyParticipants
                                                                                                            statusCodes:statusCodeOK];
    
    // Privacy
    [privacyMapping addAttributeMappingsFromArray:@[KeySlug, KeyStatus, KeyTitle, KeyDescription]];
    RKResponseDescriptor *privacyCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:privacyMapping
                                                                                                             method:RKRequestMethodGET | RKRequestMethodPUT
                                                                                                         pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIPrivacy]
                                                                                                             keyPath:KeyPrivacy
                                                                                                         statusCodes:statusCodeOK];
    
    // Push
    [pushMapping addAttributeMappingsFromArray:@[KeySlug, KeyStatus, KeyTitle, KeyDescription]];
    RKResponseDescriptor *pushCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:pushMapping
                                                                                                          method:RKRequestMethodGET | RKRequestMethodPUT
                                                                                                         pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIPush]
                                                                                                             keyPath:KeyPush
                                                                                                         statusCodes:statusCodeOK];
    
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
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIStakes]
                                                                                                keyPath:KeyStake
                                                                                            statusCodes:statusCodeCreated];
    RKResponseDescriptor *stakeEventsCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping
                                                                                                                 method:RKRequestMethodGET
                                                                                                            pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIStakes]
                                                                                                                keyPath:KeyStakes
                                                                                                            statusCodes:statusCodeOK];
    RKResponseDescriptor *stakeUsersCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping
                                                                                                                method:RKRequestMethodGET
                                                                                                           pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIStakes]
                                                                                                               keyPath:KeyStakes
                                                                                                           statusCodes:statusCodeOK];
    
    //Statistics
    [statisticsMaping addAttributeMappingsFromArray:@[KeyStakesCount, KeyWinCount, KeyLossCount, KeyWinMoney, KeyLossMoney, KeyMaximumGain]];
    
    //Socials
    [socialsMaping addAttributeMappingsFromArray:@[KeyFacebook, KeyTwitter, KeyVKontakte]];
    
    
    // Subscriber
    RKRelationshipMapping *subscriberUserRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyUser mapping:userMapping];
    [subscriberMapping addPropertyMapping:subscriberUserRelationship];
    RKResponseDescriptor *subscriberCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:subscriberMapping
                                                                                                                method:RKRequestMethodGET
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
                                                                                                                  method:RKRequestMethodGET
                                                                                                             pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APISubscriptions]
                                                                                                                 keyPath:KeySubscriptions
                                                                                                             statusCodes:statusCodeOK];
    RKResponseDescriptor *subscriptionCreateAndDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:subscriptionMapping
                                                                                                                       method:RKRequestMethodPOST | RKRequestMethodDELETE
                                                                                                                  pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APISubscriptions]
                                                                                                                      keyPath:nil
                                                                                                                  statusCodes:statusCodeNoContent];
    
    // Tournament
    [tournamentMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyBanner, KeyStakesCount, KeySubscribersCount, KeyStartTime, KeyEndTime, KeySubscribed]];
    RKRelationshipMapping *tournamentCategoryRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyCategory mapping:categoryMapping];
    [tournamentMapping addPropertyMapping:tournamentCategoryRelationship];
    RKResponseDescriptor *tournamentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tournamentMapping
                                                                                                                method:RKRequestMethodGET
                                                                                                           pathPattern:APITournaments
                                                                                                               keyPath:KeyTournaments
                                                                                                           statusCodes:statusCodeOK];
    
    // User
    [userMapping addAttributeMappingsFromArray:@[KeyTag, KeyEmail, KeyFirstName, KeyLastName, KeyUsername, KeyAvatar, KeySubscribed, KeyTopPosition, KeyRating, KeySubscriptionsCount, KeySubscribersCount, KeyBadgesCount, KeyWinCount, KeyLossCount]];
    RKRelationshipMapping *userStatisticsRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeyStatistics mapping:statisticsMaping];
    [userMapping addPropertyMapping:userStatisticsRelationship];
    RKRelationshipMapping *userSocialsRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeySocials mapping:socialsMaping];
    [userMapping addPropertyMapping:userSocialsRelationship];
    RKResponseDescriptor *userCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                          method:RKRequestMethodGET
                                                                                                     pathPattern:APIUsers
                                                                                                         keyPath:KeyUsers
                                                                                                     statusCodes:statusCodeOK];
    RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers]
                                                                                               keyPath:KeyUser
                                                                                           statusCodes:statusCodeOK];
    RKResponseDescriptor *userCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                      method:RKRequestMethodPOST
                                                                                                 pathPattern:APIUsers
                                                                                                     keyPath:KeyUser
                                                                                                 statusCodes:statusCodeCreated];
    RKResponseDescriptor *userAuthorizationCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                                   method:RKRequestMethodPOST
                                                                                                              pathPattern:APIAuthorization
                                                                                                                  keyPath:KeyUser
                                                                                                              statusCodes:statusCodeCreated];
    RKResponseDescriptor *userUpdateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                      method:RKRequestMethodPUT
                                                                                                 pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers]
                                                                                                     keyPath:nil
                                                                                                 statusCodes:statusCodeNoContent];
    RKResponseDescriptor *userPassordResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                       method:RKRequestMethodPUT
                                                                                                  pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, KeyPassword]
                                                                                                      keyPath:nil
                                                                                                  statusCodes:statusCodeNoContent];
    
    
    // User 
    [userSocialMapping addAttributeMappingsFromArray:@[KeyTag, KeyUsername, KeyAvatar, KeySocialType]];
    RKRelationshipMapping *userSocialSocialsRelationship = [RKRelationshipMapping relationshipMappingWithKeyPath:KeySocials mapping:socialsMaping];
    [userSocialMapping addPropertyMapping:userSocialSocialsRelationship];
    RKResponseDescriptor *userSocialResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userSocialMapping
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers]
                                                                                               keyPath:KeyUser
                                                                                           statusCodes:statusCodeOK];
    
    
    // Response Descriptors
    [self addResponseDescriptorsFromArray:
        @[
            activityResponseDescriptor,
            authorizationResponseDescriptor,
            authorizationUserCreateResponseDescriptor,
            awardCollectionResponseDescriptor,
            categoryCollectionResponseDescriptor,
            coefficientResponseDescriptor,
            commentCreateResponseDescriptor,
            commentResponseDescriptor,
            componentCollectionResponseDescriptor,
            copyrightResponseDescriptor,
            errorResponseDescriptor,
            eventCollectionResponseDescriptor,
            eventParticipantResponseDescriptor,
            eventTournamentCollectionResponseDescriptor,
            groupCollectionResponseDescriptor,
            moneyResponseDescriptor,
            newsCollectionResponseDescriptor,
            participantCollectionResponseDescriptor,
            privacyCollectionResponseDescriptor,
            pushCollectionResponseDescriptor,
            stakeEventsCollectionResponseDescriptor,
            stakeResponseDescriptor,
            stakeUsersCollectionResponseDescriptor,
            subscriberCollectionResponseDescriptor,
            subscriptionCollectionResponseDescriptor,
            subscriptionCreateAndDeleteResponseDescriptor,
            tournamentCollectionResponseDescriptor,
            userAuthorizationCreateResponseDescriptor,
            userCollectionResponseDescriptor,
            userCreateResponseDescriptor,
            userPassordResponseDescriptor,
            userResponseDescriptor,
            userSocialResponseDescriptor,
            userUpdateResponseDescriptor
         ]
    ];
    
    // Serialization
    
    // Comment
    RKObjectMapping *commentSerialization = [RKObjectMapping requestMapping];
    [commentSerialization addAttributeMappingsFromArray:@[KeyMessage]];
    RKRequestDescriptor *commentRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:commentSerialization
                                                                                          objectClass:[CommentModel class]
                                                                                          rootKeyPath:nil
                                                                                               method:RKRequestMethodPOST];
    
    // Credentials
    RKObjectMapping *credentialsSerialization = [RKObjectMapping requestMapping];
    [credentialsSerialization addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *credentialsRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:credentialsSerialization
                                                                                              objectClass:[CredentialsModel class]
                                                                                              rootKeyPath:KeyCredentials
                                                                                                   method:RKRequestMethodPOST];
    
    // Event
    RKObjectMapping *eventSerialization = [RKObjectMapping requestMapping];
    [eventSerialization addAttributeMappingsFromArray:@[KeyTag]];
    RKRequestDescriptor *eventRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:eventSerialization
                                                                                        objectClass:[EventModel class]
                                                                                        rootKeyPath:KeyEvent
                                                                                             method:RKRequestMethodPOST];
    
    // Facebook
    RKObjectMapping *facebookSerialization = [RKObjectMapping requestMapping];
    [facebookSerialization addAttributeMappingsFromArray:@[KeyTag, KeyAccessToken]];
    RKRequestDescriptor *facebookRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:facebookSerialization
                                                                                            objectClass:[FacebookModel class]
                                                                                            rootKeyPath:KeyFacebook
                                                                                                method:RKRequestMethodPOST];
    // Participant
    RKObjectMapping *participantSerialization = [RKObjectMapping requestMapping];
    [participantSerialization addAttributeMappingsFromArray:@[KeyTag]];
    RKRequestDescriptor *participantRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:participantSerialization
                                                                                              objectClass:[ParticipantModel class]
                                                                                              rootKeyPath:KeyParticipant
                                                                                                   method:RKRequestMethodPOST];
    
    // Password
    RKObjectMapping *passwordSerialization = [RKObjectMapping requestMapping];
    [passwordSerialization addAttributeMappingsFromArray:@[KeyPassword, KeyPasswordNew, KeyPasswordNewConfirmation]];
    RKRequestDescriptor *passwordRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:passwordSerialization
                                                                                           objectClass:[PasswordModel class]
                                                                                           rootKeyPath:nil
                                                                                                method:RKRequestMethodPUT];
    
    // Privacy
    RKObjectMapping *privacySerialization = [RKObjectMapping requestMapping];
    [privacySerialization addAttributeMappingsFromArray:@[KeySlug, KeyStatus, KeyTitle, KeyDescription]];
    RKRequestDescriptor *privacyRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:privacySerialization
                                                                                          objectClass:[PrivacySettingsModel class]
                                                                                          rootKeyPath:nil
                                                                                               method:RKRequestMethodPUT];
    
    // Push
    RKObjectMapping *pushSerialization = [RKObjectMapping requestMapping];
    [pushSerialization addAttributeMappingsFromArray:@[KeySlug, KeyStatus, KeyTitle, KeyDescription]];
    RKRequestDescriptor *pushRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:pushSerialization
                                                                                          objectClass:[PushSettingsModel class]
                                                                                          rootKeyPath:nil
                                                                                            method:RKRequestMethodPUT];
    
    // Stake
    RKObjectMapping *stakeSerialization = [RKObjectMapping requestMapping];
    [stakeSerialization addPropertyMappingsFromArray:@[
     [stakeLineRelationship copy],
     [stakeComponentRelationship copy],
     [stakeCoefficientRelationship copy],
     [stakeMoneyRelationship copy]]];
    RKRequestDescriptor *stakeRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[stakeMapping inverseMapping]
                                                                                        objectClass:[StakeModel class]
                                                                                        rootKeyPath:nil
                                                                                             method:RKRequestMethodPOST];
    
    // Twitter
    RKObjectMapping *twitterSerialization = [RKObjectMapping requestMapping];
    [twitterSerialization addAttributeMappingsFromArray:@[KeyTag, KeyAccessToken, KeySecretToken]];
    RKRequestDescriptor *twitterRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:twitterSerialization
                                                                                          objectClass:[TwitterModel class]
                                                                                          rootKeyPath:KeyTwitter
                                                                                               method:RKRequestMethodPOST];
    
    // User
    RKObjectMapping *userSerialization = [RKObjectMapping requestMapping];
    [userSerialization addAttributeMappingsFromArray:@[KeyEmail, KeyPassword, KeyFirstName, KeyLastName, KeyUsername]];
    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userSerialization
                                                                                       objectClass:[UserModel class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodPOST | RKRequestMethodPUT];
    
    // VKontakte
    RKObjectMapping *vKontakteSerialization = [RKObjectMapping requestMapping];
    [vKontakteSerialization addAttributeMappingsFromArray:@[KeyTag, KeyAccessToken]];
    RKRequestDescriptor *vKontakteRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:vKontakteSerialization
                                                                                            objectClass:[VKontakteModel class]
                                                                                            rootKeyPath:KeyVKontakte
                                                                                                 method:RKRequestMethodPOST];
    
    [self addRequestDescriptorsFromArray:
        @[
            commentRequestDescriptor,
            credentialsRequestDescriptor,
            eventRequestDescriptor,
            facebookRequestDescriptor,
            participantRequestDescriptor,
            passwordRequestDescriptor,
            privacyRequestDescriptor,
            pushRequestDescriptor,
            stakeRequestDescriptor,
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
          parameters:self.authorization.pushToken ? @{KeyPushToken: self.authorization.pushToken} : nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
             {
                 NSDictionary *response = mappingResult.dictionary;
                 AuthorizationModel *authorization = (AuthorizationModel *)response[KeyAuthorization];
                 UserModel *user = (UserModel *)response[KeyUser];
                 self.authorization.sid = authorization.sid;
                 self.authorization.secret = authorization.secret;
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

#pragma mark - Awards

- (void)awardsForUser:(UserModel *)user
               paging:(PagingModel *)paging
              success:(Awards)success
              failure:(EmptyFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.authorization.wrappedParameters];
    if (paging) {
        [parameters setObject:paging.parameters forKey:KeyPaging];
    }
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, user.tag.stringValue, APIAwards]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSArray *awards = mappingResult.dictionary[KeyAwards];
         return success(awards);
     }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self reportWithFailure:failure error:error];
     }
     ];
}

#pragma mark - Categories

- (void)categoriesWithSuccess:(Categories)success failure:(EmptyFailure)failure
{
    if (self.categories)
    {
        success(self.categories);
    }
    else
    {
        [self getObject:nil
                   path:APICategories
             parameters:self.authorization.wrappedParameters
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                {
                    NSArray *categories = mappingResult.dictionary[KeyCategories];
                    self.categories = categories;
                    success(categories);
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error)
                {
                    [self reportWithFailure:failure error:error];
                }
        ];
    }
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

#pragma mark - Copyrights

- (void)termWithSuccess:(Copyright)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@", APICopyright, APITerms]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         CopyrightModel *copyright = mappingResult.firstObject;
         success(copyright);
     }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self reportWithFailure:failure error:error];
     }
     ];
}

- (void)offerWithSuccess:(Copyright)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@", APICopyright, APIOffer]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         CopyrightModel *copyright = mappingResult.firstObject;
         success(copyright);
     }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self reportWithFailure:failure error:error];
     }
     ];
}

#pragma mark - Events

- (void)eventsWithPaging:(PagingModel *)paging
                  filter:(FilterModel *)filter
                  search:(SearchModel *)search
                 success:(Events)success
                 failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null],
                                     KeyFilter: filter ? filter.parameters : [NSNull null],
                                     KeySearch: search ? search.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:APIEvents
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *events = mappingResult.dictionary[KeyEvents];
                success(events);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
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

#pragma mark - Participants

- (void)participantsWithPaging:(PagingModel *)paging
                        filter:(FilterModel *)filter
                        search:(SearchModel *)search
                       success:(Participants)success
                       failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null],
                                     KeyFilter: filter ? filter.parameters : [NSNull null],
                                     KeySearch: search ? search.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:APIParticipants
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *participants = mappingResult.dictionary[KeyParticipants];
                success(participants);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)eventsForParticipant:(ParticipantModel *)participant
                      paging:(PagingModel *)paging
                     success:(Events)success
                     failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIParticipants, participant.tag, APIEvents]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *events = mappingResult.dictionary[KeyEvents];
                success(events);
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

#pragma mark - Subscribers

- (void)subscribersForUser:(UserModel *)user
                    paging:(PagingModel *)paging
                   success:(Subscribers)success
                   failure:(EmptyFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.authorization.wrappedParameters];
    if (paging) {
        [parameters setObject:paging.parameters forKey:KeyPaging];
    }
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, user.tag.stringValue, APISubscribers]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *subscribers = mappingResult.dictionary[KeySubscribers];
                success(subscribers);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

#pragma mark - Subscriptions

- (void)subscribeFor:(id <Parametrization>)object success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:object.wrappedParameters];
    [parameters setObject:self.authorization.parameters forKey:KeyAuthorization];
    [self postObject:nil
                path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APISubscriptions]
          parameters:parameters
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

- (void)unsubscribeFrom:(id <Parametrization>)object success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:object.wrappedParameters];
    [parameters setObject:self.authorization.parameters forKey:KeyAuthorization];
    [self deleteObject:nil
                  path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APISubscriptions]
            parameters:parameters
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

- (void)subscriptionsForUser:(UserModel *)user
                      paging:(PagingModel *)paging
                     success:(Subscriptions)success
                     failure:(EmptyFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.authorization.wrappedParameters];
    if (paging) {
        [parameters setObject:paging.parameters forKey:KeyPaging];
    }
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, user.tag.stringValue, APISubscriptions]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *subscriptions = mappingResult.dictionary[KeySubscriptions];
                return success(subscriptions);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

#pragma mark - Tournaments

- (void)tournamentsWithPaging:(PagingModel *)paging
                       filter:(FilterModel *)filter
                       search:(SearchModel *)search
                      success:(Tournaments)success
                      failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                    KeyAuthorization: self.authorization.parameters,
                                    KeyPaging: paging ? paging.parameters : [NSNull null],
                                    KeyFilter: filter ? filter.parameters : [NSNull null],
                                    KeySearch: search ? search.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:APITournaments
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *tournaments = mappingResult.dictionary[KeyTournaments];
                success(tournaments);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)eventsForTournament:(TournamentModel *)tournament
                     paging:(PagingModel *)paging
                     filter:(FilterModel *)filter
                     search:(SearchModel *)search
                    success:(Events)success
                    failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null],
                                     KeyFilter: filter ? filter.parameters : [NSNull null],
                                     KeySearch: search ? search.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APITournaments, tournament.tag.stringValue, APIEvents]
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *events = mappingResult.dictionary[KeyEvents];
                success(events);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
     ];
}

#pragma mark - User

- (void)usersWithPaging:(PagingModel *)paging
                 search:(SearchModel *)search
                success:(Users)success
                failure:(EmptyFailure)failure
{
    NSDictionary *parameters = @{
                                     KeyAuthorization: self.authorization.parameters,
                                     KeyPaging: paging ? paging.parameters : [NSNull null],
                                     KeySearch: search ? search.parameters : [NSNull null]
                                };
    [self getObject:nil
               path:APIUsers
         parameters:parameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *users = mappingResult.dictionary[KeyUsers];
                success(users);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)profileWithSuccess:(User)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@", APIUsers, self.user.tag.stringValue]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                UserModel *user = (UserModel *)mappingResult.dictionary[KeyUser];
                self.user = user;
                success(user);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)updateProfileWithUser:(UserModel *)user success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    NSData *avatarData = UIImagePNGRepresentation(user.avatarData);
    UserModel *requestUser = [user copy];
    requestUser.avatarData = nil;
    NSMutableURLRequest *request = [self multipartFormRequestWithObject:requestUser
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
    
    RKObjectRequestOperation *operation = [self objectRequestOperationWithRequest:request
                                                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                                                          {
                                                                              success();
                                                                          }
                                                                          failure:^(RKObjectRequestOperation *operation, NSError *error)
                                                                          {
                                                                              [self reportWithFailure:failure error:error];
                                                                          }
                                          ];
    [self enqueueObjectRequestOperation:operation];
}

- (void)changePassord:(PasswordModel *)password success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    [self putObject:password
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, KeyPassword]
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
    UserModel *requestUser = [user copy];
    requestUser.avatarData = nil;
    NSMutableURLRequest *request = [self multipartFormRequestWithObject:requestUser
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
            self.authorization.sid = authorization.sid;
            self.authorization.secret = authorization.secret;
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

- (void)privacyWithSuccess:(Privacy)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIPrivacy]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *privacy = mappingResult.dictionary[KeyPrivacy];
                success(privacy);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)setPrivacy:(PrivacySettingsModel *)privacy success:(Privacy)success failure:(EmptyFailure)failure
{
    [self putObject:privacy
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIPrivacy]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *privacy = mappingResult.dictionary[KeyPrivacy];
                success(privacy);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)setSocialsWithAccess:(AccessModel *)access success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    [self postObject:access
                path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APISocials]
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

- (void)disconnectSocialsWithName:(NSString *)socialNetwork success:(EmptySuccess)success failure:(EmptyFailure)failure
{
    [self deleteObject:nil
                  path:[NSString stringWithFormat:@"%@/%@/%@/%@", APIUsers, self.user.tag.stringValue, APISocials, socialNetwork]
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

- (void)pushWithSuccess:(Push)success failure:(EmptyFailure)failure
{
    [self getObject:nil
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIPush]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *push = mappingResult.dictionary[KeyPush];
                success(push);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
}

- (void)setPush:(PushSettingsModel *)push success:(Push)success failure:(EmptyFailure)failure
{
    [self putObject:push
               path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIPush]
         parameters:self.authorization.wrappedParameters
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
            {
                NSArray *push = mappingResult.dictionary[KeyPush];
                success(push);
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error)
            {
                [self reportWithFailure:failure error:error];
            }
    ];
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