//
//  ObjectManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AuthorizationModel.h"
#import "CategoryModel.h"
#import "CredentialsModel.h"
#import "ErrorModel.h"
#import "ErrorParameterModel.h"
#import "EventModel.h"
#import "FilterModel.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "PagingModel.h"
#import "ParticipantModel.h"
#import "RegistrationModel.h"
#import "StakeModel.h"
#import "StakeRequestModel.h"

@interface ObjectManager ()

@property (nonatomic, strong) AuthorizationModel *authorization;
@property (nonatomic, strong) UserModel *user;

@end

@implementation ObjectManager

- (id)initWithHTTPClient:(AFHTTPClient *)client {
    self = [super initWithHTTPClient:client];
    if (self) {
        [self setRequestSerializationMIMEType:RKMIMETypeJSON];
        [self setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    }
    return self;
}

- (void)configureMapping {
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
    // Authorization Mapping
    RKObjectMapping *authorizationMapping = [RKObjectMapping mappingForClass:[AuthorizationModel class]];
    [authorizationMapping addAttributeMappingsFromArray:@[KeySID]];
    
    RKResponseDescriptor *authorizationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIAuthorization keyPath:KeyAuthorization statusCodes:statusCodeCreated];
    RKResponseDescriptor *authorizationUsersMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIUsers keyPath:KeyAuthorization statusCodes:statusCodeCreated];
    
    // Categories Mapping
    RKObjectMapping *categoriesMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    [categoriesMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    RKResponseDescriptor *categoriesMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoriesMapping pathPattern:APICategories keyPath:KeyCategories statusCodes:statusCodeOK];
    
    // Line Mapping
    RKObjectMapping *lineMapping = [RKObjectMapping mappingForClass:[LineModel class]];
    [lineMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Event Mapping
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    [categoryMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    
    RKObjectMapping *participantsMapping = [RKObjectMapping mappingForClass:[ParticipantModel class]];
    [participantsMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    
    RKObjectMapping *eventMapping = [RKObjectMapping mappingForClass:[EventModel class]];
    [eventMapping addAttributeMappingsFromArray:@[KeyTag, KeyStakesCount, KeyCreatedAt, KeyStartTime, KeyEndTime, KeyStatus]];
    
    RKRelationshipMapping *categoryRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCategory toKeyPath:KeyCategory withMapping:categoryMapping];
    RKRelationshipMapping *participantsRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyParticipants toKeyPath:KeyParticipants withMapping:participantsMapping];
    RKRelationshipMapping *eventLineRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyLines toKeyPath:KeyLines withMapping:lineMapping];
    
    [eventMapping addPropertyMappingsFromArray:@[categoryRelationship, participantsRelationship, eventLineRelationship]];
    RKResponseDescriptor *eventMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:APIEvents keyPath:KeyEvents statusCodes:statusCodeOK];
    
    // Error Parameter Mapping
    RKObjectMapping *errorParameterMapping = [RKObjectMapping mappingForClass:[ErrorParameterModel class]];
    [errorParameterMapping addAttributeMappingsFromArray:@[KeyField, KeyType]];
    
    // Error Mapping
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ErrorModel class]];
    [errorMapping addAttributeMappingsFromArray:@[KeyMessage, KeyCode]];
    RKRelationshipMapping *errorParameterRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyErrors toKeyPath:KeyErrors withMapping:errorParameterMapping];
    [errorMapping addPropertyMappingsFromArray:@[errorParameterRelationship]];
    
    NSMutableIndexSet *errorStatusCodes = [NSMutableIndexSet indexSet];
    [errorStatusCodes addIndexes:statusCodeNotModified];
    [errorStatusCodes addIndexes:statusCodeBadRequest];
    [errorStatusCodes addIndexes:statusCodeUnauthorized];
    [errorStatusCodes addIndexes:statusCodeForbidden];
    [errorStatusCodes addIndexes:statusCodeNotFound];
    [errorStatusCodes addIndexes:statusCodeUnprocessableEntity];
    [errorStatusCodes addIndexes:statusCodeInternalServerError];
    [errorStatusCodes addIndexes:statusCodeNotImplemented];
    RKResponseDescriptor *errorMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:nil statusCodes:errorStatusCodes];
    
    
    
    // User Mapping
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[UserModel class]];
    [userMapping addAttributeMappingsFromArray:@[KeyTag, KeyEmail, KeyFirstName, KeyLastName, KeyUsername, KeyAvatar, KeyTopPosition, KeyRating, KeySubscriptionsCount, KeySubscribersCount, KeyBadgesCount, KeyWinCount, KeyLossCount]];
    RKResponseDescriptor *userMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers] keyPath:KeyUser statusCodes:statusCodeOK];
    RKResponseDescriptor *userCreationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:APIUsers keyPath:KeyUser statusCodes:statusCodeCreated];
    RKResponseDescriptor *userAuthorizationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:APIAuthorization keyPath:KeyUser statusCodes:statusCodeCreated];
    
    // Criterion Mapping
    RKObjectMapping *criterionMapping = [RKObjectMapping mappingForClass:[CriterionModel class]];
    [criterionMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Component Mapping
    RKObjectMapping *componentMapping = [RKObjectMapping mappingForClass:[ComponentModel class]];
    [componentMapping addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    RKRelationshipMapping *componentCriterionRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCriteria toKeyPath:KeyCriteria withMapping:criterionMapping];
    [componentMapping addPropertyMapping:componentCriterionRelationship];
    
    RKResponseDescriptor *componentsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:componentMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComponents] keyPath:KeyComponents statusCodes:statusCodeOK];
    
    // Coefficient Mapping
    RKObjectMapping *coefficientMapping = [RKObjectMapping mappingForClass:[CoefficientModel class]];
    [coefficientMapping addAttributeMappingsFromArray:@[KeyValue]];
    
    RKResponseDescriptor *coefficientResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coefficientMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APICoefficient] keyPath:KeyCoefficient statusCodes:statusCodeOK];
    
    // Money Mapping
    RKObjectMapping *moneyMapping = [RKObjectMapping mappingForClass:[MoneyModel class]];
    [moneyMapping addAttributeMappingsFromArray:@[KeyAmount]];
    
    RKResponseDescriptor *balanceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:moneyMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIBalance] keyPath:KeyBalance statusCodes:statusCodeOK];
    
    // Stake Mapping
    RKObjectMapping *stakeMapping = [RKObjectMapping mappingForClass:[StakeModel class]];
    [stakeMapping addAttributeMappingsFromArray:@[KeyTag, KeyCreatedAt, KeyStatus]];
    
    RKRelationshipMapping *stakeUserRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyUser toKeyPath:KeyUser withMapping:userMapping];
    RKRelationshipMapping *stakeEventRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyEvent toKeyPath:KeyEvent withMapping:eventMapping];
    RKRelationshipMapping *stakeLineRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyLine toKeyPath:KeyLine withMapping:lineMapping];
    RKRelationshipMapping *stakeComponentsRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyComponents toKeyPath:KeyComponents withMapping:componentMapping];
    RKRelationshipMapping *stakeCoefficientRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCoefficient toKeyPath:KeyCoefficient withMapping:coefficientMapping];
    RKRelationshipMapping *stakeMoneyRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyMoney toKeyPath:KeyMoney withMapping:moneyMapping];
    
    [stakeMapping addPropertyMappingsFromArray:@[stakeUserRelationship, stakeEventRelationship, stakeLineRelationship, stakeComponentsRelationship, stakeCoefficientRelationship, stakeMoneyRelationship]];
    
    RKResponseDescriptor *stakeMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIStakes keyPath:KeyStake statusCodes:statusCodeOK];
    RKResponseDescriptor *stakesMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIStakes keyPath:KeyStakes statusCodes:statusCodeOK];
    
    // Response Descriptors
    
    [self addResponseDescriptorsFromArray:@[
     eventMappingResponseDescriptor,
     authorizationMappingResponseDescriptor,
     authorizationUsersMappingResponseDescriptor,
     errorMappingResponseDescriptor,
     categoriesMappingResponseDescriptor,
     stakeMappingResponseDescriptor,
     stakesMappingResponseDescriptor,
     componentsResponseDescriptor,
     coefficientResponseDescriptor,
     balanceResponseDescriptor,
     userMappingResponseDescriptor,
     userAuthorizationMappingResponseDescriptor,
     userCreationMappingResponseDescriptor
     ]];
    
    // Serialization
    
    // Credentials Serialization
    RKObjectMapping *credentialsMapping = [RKObjectMapping requestMapping];
    [credentialsMapping addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *credentialsRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:credentialsMapping objectClass:[CredentialsModel class] rootKeyPath:KeyCredentials];
    
    // Registration Serialization
    RKObjectMapping *registrationSerialization = [RKObjectMapping requestMapping];
    [registrationSerialization addAttributeMappingsFromArray:@[KeyEmail, KeyPassword, KeyUsername, KeyFirstName, KeyLastName]];
    RKRequestDescriptor *registrationRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:registrationSerialization objectClass:[RegistrationModel class] rootKeyPath:nil];
    
    // Authorization Serialization
    RKObjectMapping *authorizationSerialization = [RKObjectMapping requestMapping];
    [authorizationSerialization addAttributeMappingsFromArray:@[KeyTag, KeySID]];
    RKRequestDescriptor *authorizationRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:authorizationSerialization objectClass:[AuthorizationModel class] rootKeyPath:nil];
    
    // Components Serialization
    RKObjectMapping *componentsSerialization = [RKObjectMapping requestMapping];
    [componentsSerialization addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    RKRequestDescriptor *componentsRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:componentsSerialization objectClass:[ComponentModel class] rootKeyPath:KeyComponents];
    
    RKObjectMapping *componentsSerializationMapping = [RKObjectMapping mappingForClass:[ComponentModel class]];
    [componentsSerializationMapping addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    
    // Stake Request Serialization
    RKObjectMapping *stakeRequestSerialization = [RKObjectMapping requestMapping];
    [stakeRequestSerialization addAttributeMappingsFromArray:@[KeyLine]];
    RKRelationshipMapping *stakeRequestComponentsRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyComponents toKeyPath:KeyComponents withMapping:componentsSerializationMapping];
    RKRelationshipMapping *stakeRequestCoefficientRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCoefficient toKeyPath:KeyCoefficient withMapping:coefficientMapping];
    RKRelationshipMapping *stakeRequestMoneyRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyMoney toKeyPath:KeyMoney withMapping:moneyMapping];
    [stakeRequestSerialization addPropertyMappingsFromArray:@[stakeRequestComponentsRelationship, stakeRequestCoefficientRelationship, stakeRequestMoneyRelationship]];
    RKRequestDescriptor *stakeRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:stakeRequestSerialization objectClass:[StakeRequestModel class] rootKeyPath:nil];
    
    [self addRequestDescriptorsFromArray:@[
     credentialsRequestDescriptor,
     registrationRequestDescriptor,
     authorizationRequestDescriptor,
     componentsRequestDescriptor,
     stakeRequestDescriptor
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
        [NotificationManager showError:error];
        failure();
    }];
}

- (void)logOutWithSuccess:(EmptySuccess)success failure:(EmptyFailure)failure {
    [self.HTTPClient deletePath:APIAuthorization parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NotificationManager showError:error];
        failure();
    }];
}

#pragma mark - Categories

- (void)categoriesWithSuccess:(Categories)success failure:(EmptyFailure)failure {
    [self getObject:nil path:APICategories parameters:@{KeySID: self.authorization.sid} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *categories = mappingResult.dictionary[KeyCategories];
        success(categories);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [NotificationManager showError:error];
        failure();
    }];
}

#pragma mark - Events

- (void)eventsWithFilter:(FilterModel *)filter paging:(PagingModel *)paging success:(Events)success failure:(EmptyFailure)failure {
    
}

- (void)eventsForGroup:(NSString *)group limit:(NSNumber *)limit success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self eventsForGroup:group filter:nil search:nil limit:limit page:nil success:success failure:failure];
}

- (void)eventsForGroup:(NSString *)group filter:(NSArray *)categoryTags search:(NSString *)search limit:(NSNumber *)limit page:(NSNumber *)page success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    
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
    
    [self getObject:nil path:APIEvents parameters:parameters success:success failure:failure];
}

#pragma mark - Registration

- (void)registration:(RegistrationModel *)registration success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:registration path:APIUsers parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary *response = mappingResult.dictionary;
        self.authorization = (AuthorizationModel *)response[KeyAuthorization];
        self.user = (UserModel *)response[KeyUser];
        success(operation, mappingResult);
    } failure:failure];
}

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@", APIUsers, self.user.tag.stringValue] parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

- (void)userWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@", APIUsers, userTag.stringValue] parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

- (void)userSubscriptionsWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, userTag.stringValue, APISubscriptions] parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

- (NSNumber *)loginedUserTag {
    return self.user.tag;
}

#pragma mark - Balance

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.user.tag.stringValue, APIBalance] parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

#pragma mark - Stakes

- (void)componentsForEvent:(EventModel *)event line:(LineModel *)line success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APIComponents] parameters:@{KeySID: self.authorization.sid, KeyLine: line.tag} success:success failure:failure];
}

- (void)coefficientForEvent:(EventModel *)event line:(LineModel *)line components:(NSArray *)components success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{KeySID: self.authorization.sid, KeyLine: line.tag}];
    NSMutableArray *componentsParamenters = [NSMutableArray arrayWithCapacity:components.count];
    for (ComponentModel *component in components) {
        [componentsParamenters addObject:@{KeyPosition: component.position, KeySelectedCriterion: component.selectedCriterion}];
    }
    [parameters setObject:[componentsParamenters copy] forKey:KeyComponents];
    
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%i/%@", APIEvents, event.tag.integerValue, APICoefficient] parameters:[parameters copy] success:success failure:failure];
}

- (void)setStakeForEvent:(NSNumber *)event success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:nil path:[NSString stringWithFormat:@"events/%i/stakes", event.integerValue] parameters:@{KeySID: self.authorization.sid, @"amount": @50} success:success failure:failure];
}

@end
