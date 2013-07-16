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
    // Event Mapping
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
    [categoryMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    
    RKObjectMapping *participantsMapping = [RKObjectMapping mappingForClass:[ParticipantModel class]];
    [participantsMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    
    RKObjectMapping *eventMapping = [RKObjectMapping mappingForClass:[EventModel class]];
    [eventMapping addAttributeMappingsFromArray:@[KeyTag, KeyStakesCount, KeyCreatedAt, KeyStartTime, KeyEndTime, KeyStatus]];
    
    RKRelationshipMapping *categoryRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCategory toKeyPath:KeyCategory withMapping:categoryMapping];
    RKRelationshipMapping *participantsRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyParticipants toKeyPath:KeyParticipants withMapping:participantsMapping];
    
    [eventMapping addPropertyMappingsFromArray:@[categoryRelationship, participantsRelationship]];
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
    
    // Stake Mapping
    RKObjectMapping *stakeMapping = [RKObjectMapping mappingForClass:[StakeModel class]];
    [stakeMapping addAttributeMappingsFromArray:@[KeyTag]];
    RKResponseDescriptor *stakeMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stakeMapping pathPattern:APIEvents keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:201]];
    
    [self addResponseDescriptorsFromArray:@[eventMappingResponseDescriptor, authorizationMappingResponseDescriptor, registrationMappingResponseDescriptor, errorMappingResponseDescriptor, categoriesMappingResponseDescriptor, stakeMappingResponseDescriptor]];
    
    // Serialization
    
    // Enter Serialization
    RKObjectMapping *enterMapping = [RKObjectMapping requestMapping];
    [enterMapping addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *enterRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:enterMapping objectClass:[EnterModel class] rootKeyPath:nil];
    
    // Registration Serialization
    RKObjectMapping *registrationSerialization = [RKObjectMapping requestMapping];
    [registrationSerialization addAttributeMappingsFromArray:@[KeyEmail, KeyPassword, KeyUsername, KeyFirstName, KeyLastName]];
    RKRequestDescriptor *registrationRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:registrationSerialization objectClass:[RegistrationModel class] rootKeyPath:nil];
    
    RKObjectMapping *authorizationSerialization = [RKObjectMapping requestMapping];
    [authorizationSerialization addAttributeMappingsFromArray:@[KeyTag, KeySID]];
    RKRequestDescriptor *authorizationRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:authorizationSerialization objectClass:[AuthorizationModel class] rootKeyPath:nil];
    
    [self addRequestDescriptorsFromArray:@[enterRequestDescriptor, registrationRequestDescriptor, authorizationRequestDescriptor]];
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

- (void)setStakeForEvent:(NSNumber *)event success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:nil path:[NSString stringWithFormat:@"events/%i/stakes", event.integerValue] parameters:@{KeySID: self.authorization.sid, @"amount": @50} success:success failure:failure];
}

@end
