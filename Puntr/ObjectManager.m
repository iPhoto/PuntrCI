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
        [self setRequestSerializationMIMEType:RKMIMETypeJSON];
        [self setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    }
    return self;
}

- (void)configureMapping
{
    // Status Codes
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSIndexSet *statusCodeCreated = [NSIndexSet indexSetWithIndex:201];
    NSIndexSet *statusCodeOK = [NSIndexSet indexSetWithIndex:200];
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
#pragma clang diagnostic pop
    
    // Mapping Declaration
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[ActivityModel class]];
    RKObjectMapping *authorizationMapping = [RKObjectMapping mappingForClass:[AuthorizationModel class]];
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    RKObjectMapping *coefficientMapping = [RKObjectMapping mappingForClass:[CoefficientModel class]];
    RKObjectMapping *componentMapping = [RKObjectMapping mappingForClass:[ComponentModel class]];
    RKObjectMapping *criterionMapping = [RKObjectMapping mappingForClass:[CriterionModel class]];
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ErrorModel class]];
    RKObjectMapping *errorParameterMapping = [RKObjectMapping mappingForClass:[ErrorParameterModel class]];
    RKObjectMapping *eventMapping = [RKObjectMapping mappingForClass:[EventModel class]];
    RKObjectMapping *feedMapping = [RKObjectMapping mappingForClass:[FeedModel class]];
    RKObjectMapping *lineMapping = [RKObjectMapping mappingForClass:[LineModel class]];
    RKObjectMapping *moneyMapping = [RKObjectMapping mappingForClass:[MoneyModel class]];
    RKObjectMapping *participantMapping = [RKObjectMapping mappingForClass:[ParticipantModel class]];
    RKObjectMapping *stakeMapping = [RKObjectMapping mappingForClass:[StakeModel class]];
    RKObjectMapping *tournamentMapping = [RKObjectMapping mappingForClass:[TournamentModel class]];
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[UserModel class]];
    
    // Mapping
    
    // Activity
    [activityMapping addAttributeMappingsFromArray:@[KeyTag]];
    RKRelationshipMapping *activityStakeRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyStake toKeyPath:KeyStake withMapping:stakeMapping];
    RKRelationshipMapping *activityFeedRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyFeed toKeyPath:KeyFeed withMapping:feedMapping];
    [activityMapping addPropertyMappingsFromArray:@[activityStakeRelationship, activityFeedRelationship]];
    RKResponseDescriptor *activityResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:activityMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIActivities] keyPath:KeyActivities statusCodes:statusCodeOK];
    
    // Authorization
    [authorizationMapping addAttributeMappingsFromArray:@[KeySID]];
    RKResponseDescriptor *authorizationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIAuthorization keyPath:KeyAuthorization statusCodes:statusCodeCreated];
    RKResponseDescriptor *authorizationUserCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIUsers keyPath:KeyAuthorization statusCodes:statusCodeCreated];
    
    // Category
    [categoryMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    RKResponseDescriptor *categoryCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping pathPattern:APICategories keyPath:KeyCategories statusCodes:statusCodeOK];
    
    // Coefficient
    [coefficientMapping addAttributeMappingsFromArray:@[KeyValue]];
    RKResponseDescriptor *coefficientResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coefficientMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APICoefficient] keyPath:KeyCoefficient statusCodes:statusCodeOK];
    
    // Component
    [componentMapping addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    RKRelationshipMapping *componentCriterionRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCriteria toKeyPath:KeyCriteria withMapping:criterionMapping];
    [componentMapping addPropertyMapping:componentCriterionRelationship];
    RKResponseDescriptor *componentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:componentMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComponents] keyPath:KeyComponents statusCodes:statusCodeOK];
    
    // Criterion
    [criterionMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Error
    [errorMapping addAttributeMappingsFromArray:@[KeyMessage, KeyCode]];
    RKRelationshipMapping *errorParameterRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyErrors toKeyPath:KeyErrors withMapping:errorParameterMapping];
    [errorMapping addPropertyMapping:errorParameterRelationship];
    NSMutableIndexSet *errorStatusCodes = [NSMutableIndexSet indexSet];
    [errorStatusCodes addIndexes:statusCodeNotModified];
    [errorStatusCodes addIndexes:statusCodeBadRequest];
    [errorStatusCodes addIndexes:statusCodeUnauthorized];
    [errorStatusCodes addIndexes:statusCodeForbidden];
    [errorStatusCodes addIndexes:statusCodeNotFound];
    [errorStatusCodes addIndexes:statusCodeUnprocessableEntity];
    [errorStatusCodes addIndexes:statusCodeInternalServerError];
    [errorStatusCodes addIndexes:statusCodeNotImplemented];
    RKResponseDescriptor *errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:nil statusCodes:errorStatusCodes];
    
    // Error Parameter
    [errorParameterMapping addAttributeMappingsFromArray:@[KeyField, KeyType]];
    
    // Event
    [eventMapping addAttributeMappingsFromArray:@[KeyTag, KeyStakesCount, KeyCreatedAt, KeyStartTime, KeyEndTime, KeyStatus]];
    RKRelationshipMapping *eventCategoryRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCategory toKeyPath:KeyCategory withMapping:categoryMapping];
    RKRelationshipMapping *eventParticipantRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyParticipants toKeyPath:KeyParticipants withMapping:participantMapping];
    RKRelationshipMapping *eventLineRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyLines toKeyPath:KeyLines withMapping:lineMapping];
    [eventMapping addPropertyMappingsFromArray:@[eventCategoryRelationship, eventParticipantRelationship, eventLineRelationship]];
    RKResponseDescriptor *eventCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:APIEvents keyPath:KeyEvents statusCodes:statusCodeOK];
    
    // Line
    [lineMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Money
    [moneyMapping addAttributeMappingsFromArray:@[KeyAmount]];
    RKResponseDescriptor *moneyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:moneyMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIBalance] keyPath:KeyBalance statusCodes:statusCodeOK];
    
    // Participant
    [participantMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyLogo, KeySubscribersCount]];
    
    // Stake
    [stakeMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt, KeyStatus]];
    RKRelationshipMapping *stakeUserRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyUser toKeyPath:KeyUser withMapping:userMapping];
    RKRelationshipMapping *stakeEventRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyEvent toKeyPath:KeyEvent withMapping:eventMapping];
    RKRelationshipMapping *stakeLineRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyLine toKeyPath:KeyLine withMapping:lineMapping];
    RKRelationshipMapping *stakeComponentRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyComponents toKeyPath:KeyComponents withMapping:componentMapping];
    RKRelationshipMapping *stakeCoefficientRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCoefficient toKeyPath:KeyCoefficient withMapping:coefficientMapping];
    RKRelationshipMapping *stakeMoneyRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyMoney toKeyPath:KeyMoney withMapping:moneyMapping];
    [stakeMapping addPropertyMappingsFromArray:@[stakeUserRelationship, stakeEventRelationship, stakeLineRelationship, stakeComponentRelationship, stakeCoefficientRelationship, stakeMoneyRelationship]];
    RKResponseDescriptor *stakeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIStakes keyPath:KeyStake statusCodes:statusCodeOK];
    RKResponseDescriptor *stakeCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIStakes keyPath:KeyStakes statusCodes:statusCodeOK];
    
    // Tournament
    [tournamentMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyStakesCount, KeyStartTime, KeyEndTime]];
    RKRelationshipMapping *tournamentCategoryRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCategory toKeyPath:KeyCategory withMapping:categoryMapping];
    [tournamentMapping addPropertyMapping:tournamentCategoryRelationship];
    RKResponseDescriptor *tournamentCollectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tournamentMapping pathPattern:APITournaments keyPath:KeyTournaments statusCodes:statusCodeOK];
    
    // User
    [userMapping addAttributeMappingsFromArray:@[KeyTag, KeyEmail, KeyFirstName, KeyLastName, KeyUsername, KeyAvatar, KeyTopPosition, KeyRating, KeySubscriptionsCount, KeySubscribersCount, KeyBadgesCount, KeyWinCount, KeyLossCount]];
    RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers] keyPath:KeyUser statusCodes:statusCodeOK];
    RKResponseDescriptor *userCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:APIUsers keyPath:KeyUser statusCodes:statusCodeCreated];
    RKResponseDescriptor *userAuthorizationCreateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:APIAuthorization keyPath:KeyUser statusCodes:statusCodeCreated];

    // Response Descriptors
    [self addResponseDescriptorsFromArray:@[
     activityResponseDescriptor,
     authorizationResponseDescriptor,
     authorizationUserCreateResponseDescriptor,
     moneyResponseDescriptor,
     categoryCollectionResponseDescriptor,
     coefficientResponseDescriptor,
     componentCollectionResponseDescriptor,
     errorResponseDescriptor,
     eventCollectionResponseDescriptor,
     stakeResponseDescriptor,
     stakeCollectionResponseDescriptor,
     tournamentCollectionResponseDescriptor,
     userAuthorizationCreateResponseDescriptor,
     userCreateResponseDescriptor,
     userResponseDescriptor
     ]];
    
    // Serialization
    
    // Credentials
    RKObjectMapping *credentialsMapping = [RKObjectMapping requestMapping];
    [credentialsMapping addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *credentialsRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:credentialsMapping objectClass:[CredentialsModel class] rootKeyPath:KeyCredentials];
    
    // Stake
    RKObjectMapping *stakeSerialization = [RKObjectMapping requestMapping];
    [stakeSerialization addPropertyMappingsFromArray:@[
     [stakeLineRelationship copy],
     [stakeComponentRelationship copy],
     [stakeCoefficientRelationship copy],
     [stakeMoneyRelationship copy]]];
    RKRequestDescriptor *stakeRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[stakeMapping inverseMapping] objectClass:[StakeModel class] rootKeyPath:nil];
    
    // User
    RKObjectMapping *userSerialization = [RKObjectMapping requestMapping];
    [userSerialization addAttributeMappingsFromArray:@[KeyEmail, KeyPassword, KeyFirstName, KeyLastName, KeyUsername]];
    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userSerialization objectClass:[UserModel class] rootKeyPath:nil];
    
    [self addRequestDescriptorsFromArray:@[
     credentialsRequestDescriptor,
     stakeRequestDescriptor,
     userRequestDescriptor
     ]];
}

#pragma mark - Authorization

- (void)logInWithCredentials:(CredentialsModel *)credentials success:(AuthorizationUser)success failure:(EmptyFailure)failure {
    [self postObject:credentials path:APIAuthorization parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary *response = mappingResult.dictionary;
        AuthorizationModel *authorization = (AuthorizationModel *)response[KeyAuthorization];
        UserModel *user = (UserModel *)response[KeyUser];
        self.authorization = authorization;
        self.user = user;
        success(authorization, user);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self reportWithFailure:failure error:error];
    }];
}

- (void)logOutWithSuccess:(EmptySuccess)success failure:(EmptyFailure)failure {
    [self.HTTPClient deletePath:APIAuthorization parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reportWithFailure:failure error:error];
    }];
}

#pragma mark - Categories

- (void)categoriesWithSuccess:(Categories)success failure:(EmptyFailure)failure {
    [self getObject:nil path:APICategories parameters:self.authorization.parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *categories = mappingResult.dictionary[KeyCategories];
        success(categories);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self reportWithFailure:failure error:error];
    }];
}

#pragma mark - Events

- (void)eventsWithFilter:(FilterModel *)filter paging:(PagingModel *)paging success:(Events)success failure:(EmptyFailure)failure {
    
}

- (void)eventsForGroup:(NSString *)group limit:(NSNumber *)limit success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self eventsForGroup:group filter:nil search:nil limit:limit page:nil success:success failure:failure];
}

- (void)eventsForGroup:(NSString *)group filter:(NSArray *)categoryTags search:(NSString *)search limit:(NSNumber *)limit page:(NSNumber *)page success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.authorization.parameters];
    if (group) {
        [parameters setObject:group forKey:KeyGroup];
    }
    if (categoryTags && categoryTags.count != 0 && ![categoryTags[0] isEqualToNumber:@0]) {
        [parameters setObject:categoryTags forKey:KeyFilter];
    }
    if (search) {
        [parameters setObject:search forKey:KeySearch];
    }
    if (limit) {
        [parameters setObject:limit forKey:KeyLimit];
    }
    if (page && limit) {
        [parameters setObject:@(page.integerValue * limit.integerValue) forKey:KeyOffset];
    }
    
    [self getObject:nil path:APIEvents parameters:parameters success:success failure:failure];
}

#pragma mark - Stakes

- (void)componentsForEvent:(EventModel *)event line:(LineModel *)line success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIComponents] parameters:@{KeyAuthorization: self.authorization.parameters[KeyAuthorization], KeyLine: @{KeyTag: line.tag}} success:success failure:failure];
}

- (void)coefficientForEvent:(EventModel *)event line:(LineModel *)line components:(NSArray *)components success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{KeyAuthorization: self.authorization.parameters[KeyAuthorization], KeyLine: @{KeyTag: line.tag}}];
    NSMutableArray *componentsParamenters = [NSMutableArray arrayWithCapacity:components.count];
    for (ComponentModel *component in components) {
        [componentsParamenters addObject:@{KeyPosition: component.position, KeySelectedCriterion: component.selectedCriterion}];
    }
    [parameters setObject:[componentsParamenters copy] forKey:KeyComponents];
    
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APICoefficient] parameters:[parameters copy] success:success failure:failure];
}

- (void)setStake:(StakeModel *)stake success:(Tag)success failure:(EmptyFailure)failure {
    EventModel *event = stake.event;
    [stake prepareForTransmission];
    [self postObject:stake
                path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIStakes]
          parameters:self.authorization.parameters
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 
                 success(operation.locationHeader);
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 
                 [self reportWithFailure:failure error:error];
                 
             }];
    
}

#pragma mark - Tournaments

- (void)tournamentssForGroup:(NSString *)group limit:(NSNumber *)limit success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self tournamentsForGroup:group filter:nil search:nil limit:limit page:nil success:success failure:failure];
}

- (void)tournamentsForGroup:(NSString *)group filter:(NSArray *)categoryTags search:(NSString *)search limit:(NSNumber *)limit page:(NSNumber *)page success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{KeyAuthorization: @{KeySID: self.authorization.sid}}];
    if (group) {
        [parameters setObject:group forKey:KeyGroup];
    }
    if (categoryTags && categoryTags.count != 0 && ![categoryTags[0] isEqualToNumber:@0]) {
        [parameters setObject:categoryTags forKey:KeyFilter];
    }
    if (search) {
        [parameters setObject:search forKey:KeySearch];
    }
    if (limit) {
        [parameters setObject:limit forKey:KeyLimit];
    }
    if (page && limit) {
        [parameters setObject:@(page.integerValue * limit.integerValue) forKey:KeyOffset];
    }
    
    [self getObject:nil path:APITournaments parameters:parameters success:success failure:failure];
}

#pragma mark - Subscriptions

- (void)userSubscriptionsWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, userTag.stringValue, APISubscriptions] parameters:self.authorization.parameters success:success failure:failure];
}

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@", APIUsers, self.user.tag.stringValue] parameters:self.authorization.parameters success:success failure:failure];
}

- (void)userWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@", APIUsers, userTag.stringValue] parameters:self.authorization.parameters success:success failure:failure];
}

- (void)registerWithUser:(UserModel *)user success:(AuthorizationUser)success failure:(EmptyFailure)failure {
    [self postObject:user path:APIUsers parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary *response = mappingResult.dictionary;
        AuthorizationModel *authorization = (AuthorizationModel *)response[KeyAuthorization];
        UserModel *user = (UserModel *)response[KeyUser];
        self.authorization = authorization;
        self.user = user;
        success(authorization, user);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self reportWithFailure:failure error:error];
    }];
}

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIBalance] parameters:self.authorization.parameters success:success failure:failure];
}

- (NSNumber *)loginedUserTag {
    return self.user.tag;
}

#pragma mark - Helpers

- (void)reportWithFailure:(EmptyFailure)failure error:(NSError *)error {
    [NotificationManager showError:error];
    if (failure) {
        failure();
    }
}

@end