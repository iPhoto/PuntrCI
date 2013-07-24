//
//  ObjectManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ObjectManager.h"
#import "EventModel.h"
#import "CategoryModel.h"
#import "ParticipantModel.h"
#import "AuthorizationModel.h"
#import "RegistrationModel.h"
#import "EnterModel.h"
#import "ErrorModel.h"
#import "ErrorParameterModel.h"
#import "StakeModel.h"
#import "StakeRequestModel.h"

@interface ObjectManager ()

@property (nonatomic, strong) AuthorizationModel *authorization;

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
    RKResponseDescriptor *eventMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:APIEvents keyPath:KeyEvents statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Authorization Mapping
    RKObjectMapping *authorizationMapping = [RKObjectMapping mappingForClass:[AuthorizationModel class]];
    [authorizationMapping addAttributeMappingsFromArray:@[KeyTag, KeySID]];
    
    RKResponseDescriptor *authorizationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIAuthorization keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *registrationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIUsers keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Error Parameter Mapping
    RKObjectMapping *errorParameterMapping = [RKObjectMapping mappingForClass:[ErrorParameterModel class]];
    [errorParameterMapping addAttributeMappingsFromArray:@[KeyField, KeyType]];
    
    // Error Mapping
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ErrorModel class]];
    [errorMapping addAttributeMappingsFromArray:@[KeyMessage, KeyCode]];
    RKRelationshipMapping *errorParameterRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyErrors toKeyPath:KeyErrors withMapping:errorParameterMapping];
    [errorMapping addPropertyMappingsFromArray:@[errorParameterRelationship]];
    
    NSMutableIndexSet *errorStatusCodes = [NSMutableIndexSet indexSet];
    [errorStatusCodes addIndex:304];
    [errorStatusCodes addIndex:400];
    [errorStatusCodes addIndex:401];
    [errorStatusCodes addIndex:403];
    [errorStatusCodes addIndex:404];
    [errorStatusCodes addIndex:422];
    [errorStatusCodes addIndex:500];
    RKResponseDescriptor *errorMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:nil statusCodes:errorStatusCodes];
    
    // Categories Mapping
    RKObjectMapping *categoriesMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    [categoriesMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    RKResponseDescriptor *categoriesMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoriesMapping pathPattern:APICategories keyPath:KeyCategories statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // User Mapping
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[UserModel class]];
    [userMapping addAttributeMappingsFromArray:@[KeyTag, KeyEmail, KeyFirstName, KeyLastName, KeyUsername, KeyAvatar, KeyTopPosition, KeyRating, KeySubscriptionsCount, KeySubscribersCount, KeyBadgesCount, KeyWinCount, KeyLossCount]];
    RKResponseDescriptor *userMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:[NSString stringWithFormat:@"%@/:tag", APIUsers] keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // Criterion Mapping
    RKObjectMapping *criterionMapping = [RKObjectMapping mappingForClass:[CriterionModel class]];
    [criterionMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle]];
    
    // Component Mapping
    RKObjectMapping *componentMapping = [RKObjectMapping mappingForClass:[ComponentModel class]];
    [componentMapping addAttributeMappingsFromArray:@[KeyPosition, KeySelectedCriterion]];
    RKRelationshipMapping *componentCriterionRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCriteria toKeyPath:KeyCriteria withMapping:criterionMapping];
    [componentMapping addPropertyMapping:componentCriterionRelationship];
    
    RKResponseDescriptor *componentsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:componentMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APIComponents] keyPath:KeyComponents statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // Coefficient Mapping
    RKObjectMapping *coefficientMapping = [RKObjectMapping mappingForClass:[CoefficientModel class]];
    [coefficientMapping addAttributeMappingsFromArray:@[KeyValue]];
    
    RKResponseDescriptor *coefficientResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coefficientMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIEvents, APICoefficient] keyPath:KeyCoefficient statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // Money Mapping
    RKObjectMapping *moneyMapping = [RKObjectMapping mappingForClass:[MoneyModel class]];
    [moneyMapping addAttributeMappingsFromArray:@[KeyAmount]];
    
    RKResponseDescriptor *balanceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:moneyMapping pathPattern:[NSString stringWithFormat:@"%@/:tag/%@", APIUsers, APIBalance] keyPath:KeyBalance statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
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
    
    RKResponseDescriptor *stakeMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIStakes keyPath:KeyStake statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor *stakesMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIStakes keyPath:KeyStakes statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // Response Descriptors
    
    [self addResponseDescriptorsFromArray:@[eventMappingResponseDescriptor, authorizationMappingResponseDescriptor, registrationMappingResponseDescriptor, errorMappingResponseDescriptor, categoriesMappingResponseDescriptor, stakeMappingResponseDescriptor, stakesMappingResponseDescriptor, componentsResponseDescriptor, coefficientResponseDescriptor, balanceResponseDescriptor, userMappingResponseDescriptor]];
    
    // Serialization
    
    // Enter Serialization
    RKObjectMapping *enterMapping = [RKObjectMapping requestMapping];
    [enterMapping addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *enterRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:enterMapping objectClass:[EnterModel class] rootKeyPath:nil];
    
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
    
    [self addRequestDescriptorsFromArray:@[enterRequestDescriptor, registrationRequestDescriptor, authorizationRequestDescriptor, componentsRequestDescriptor, stakeRequestDescriptor]];
}

#pragma mark - Authorization

- (void)enter:(EnterModel *)enter success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:enter path:APIAuthorization parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (![mappingResult.firstObject isMemberOfClass:[ErrorModel class]]) {
            self.authorization = mappingResult.firstObject;
        }
        success(operation, mappingResult);
    } failure:failure];
}

#pragma mark - Registration

- (void)registration:(RegistrationModel *)registration success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:registration path:APIUsers parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.authorization = mappingResult.firstObject;
        success(operation, mappingResult);
    } failure:failure];
}

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@", APIUsers, self.authorization.tag.stringValue] parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

#pragma mark - Balance

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:[NSString stringWithFormat:@"%@/%@/%@", APIUsers, self.authorization.tag.stringValue, APIBalance] parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

#pragma mark - Categories

- (void)categoriesWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self getObject:nil path:APICategories parameters:@{KeySID: self.authorization.sid} success:success failure:failure];
}

#pragma mark - Events

- (void)eventsForGroup:(NSString *)group limit:(NSNumber *)limit success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self eventsForGroup:group filter:nil search:nil limit:limit page:nil success:success failure:failure];
}

- (void)eventsForGroup:(NSString *)group filter:(NSArray *)categoryTags search:(NSString *)search limit:(NSNumber *)limit page:(NSNumber *)page success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{KeySID: self.authorization.sid}];
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
