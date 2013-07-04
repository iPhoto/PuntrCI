//
//  TNIObjectManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIObjectManager.h"
#import "TNIEvent.h"
#import "TNICategory.h"
#import "TNIParticipants.h"
#import "TNIAuthorization.h"
#import "TNIRegistration.h"
#import "TNIEnter.h"
#import "TNIError.h"
#import "TNIErrorParameter.h"

@interface TNIObjectManager ()

@property (nonatomic, strong) TNIAuthorization *authorization;

@end

@implementation TNIObjectManager

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
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[TNICategory class]];
    [categoryMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    
    RKObjectMapping *participantsMapping = [RKObjectMapping mappingForClass:[TNIParticipants class]];
    [participantsMapping addAttributeMappingsFromArray:@[KeyTag, KeyTitle, KeyImage]];
    
    RKObjectMapping *eventMapping = [RKObjectMapping mappingForClass:[TNIEvent class]];
    [eventMapping addAttributeMappingsFromArray:@[KeyTag, KeyStakesCount, KeyCreatedAt, KeyStartTime, KeyEndTime, KeyStatus]];
    
    RKRelationshipMapping *categoryRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyCategory toKeyPath:KeyCategory withMapping:categoryMapping];
    RKRelationshipMapping *participantsRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:KeyParticipants toKeyPath:KeyParticipants withMapping:participantsMapping];
    
    [eventMapping addPropertyMappingsFromArray:@[categoryRelationship, participantsRelationship]];
    RKResponseDescriptor *eventMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:APIEvents keyPath:KeyEvents statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Authorization Mapping
    RKObjectMapping *authorizationMapping = [RKObjectMapping mappingForClass:[TNIAuthorization class]];
    [authorizationMapping addAttributeMappingsFromArray:@[KeyTag, KeySID]];
    
    RKResponseDescriptor *authorizationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIAuthorization keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *registrationMappingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authorizationMapping pathPattern:APIUsers keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Error Parameter Mapping
    RKObjectMapping *errorParameterMapping = [RKObjectMapping mappingForClass:[TNIErrorParameter class]];
    [errorParameterMapping addAttributeMappingsFromArray:@[KeyField, KeyType]];
    
    // Error Mapping
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[TNIError class]];
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
    
    [self addResponseDescriptorsFromArray:@[eventMappingResponseDescriptor, authorizationMappingResponseDescriptor, registrationMappingResponseDescriptor, errorMappingResponseDescriptor]];
    
    // Enter Serialization
    RKObjectMapping *enterMapping = [RKObjectMapping requestMapping];
    [enterMapping addAttributeMappingsFromArray:@[KeyLogin, KeyPassword]];
    RKRequestDescriptor *enterRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:enterMapping objectClass:[TNIEnter class] rootKeyPath:nil];
    
    //Registration Serialization
    RKObjectMapping *registrationMapping = [RKObjectMapping requestMapping];
    [registrationMapping addAttributeMappingsFromArray:@[KeyEmail, KeyPassword, KeyUsername, KeyFirstName, KeyLastName]];
    RKRequestDescriptor *registrationRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:registrationMapping objectClass:[TNIRegistration class] rootKeyPath:nil];
    
    [self addRequestDescriptorsFromArray:@[enterRequestDescriptor, registrationRequestDescriptor]];
}

#pragma mark - Authorization

- (void)enter:(TNIEnter *)enter success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:enter path:APIAuthorization parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (![mappingResult.firstObject isMemberOfClass:[TNIError class]]) {
            self.authorization = mappingResult.firstObject;
        }
        success(operation, mappingResult);
    } failure:failure];
}

#pragma mark - Registration

- (void)registration:(TNIRegistration *)registration success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self postObject:registration path:APIUsers parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.authorization = mappingResult.firstObject;
        success(operation, mappingResult);
    } failure:failure];
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
    if (categoryTags) {
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
