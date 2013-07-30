//
//  ObjectManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RKObjectManager.h"
@class EnterModel, RegistrationModel, EventModel, LineModel;

typedef void (^ObjectRequestSuccess)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^ObjectRequestFailure)(RKObjectRequestOperation *operation, NSError *error);

@interface ObjectManager : RKObjectManager

- (void)configureMapping;

#pragma mark - Authorization

- (void)enter:(EnterModel *)enter success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - Registration

- (void)registration:(RegistrationModel *)registration success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - User

- (void)profileWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)userWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)userSubscriptionsWithTag:(NSNumber *)userTag success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (NSNumber *)loginedUserTag;

#pragma mark - Balance

- (void)balanceWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - Categories

- (void)categoriesWithSuccess:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - Events

- (void)eventsForGroup:(NSString *)group limit:(NSNumber *)limit success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)eventsForGroup:(NSString *)group
                filter:(NSArray *)categoryTags
                search:(NSString *)search
                 limit:(NSNumber *)limit
                  page:(NSNumber *)page
               success:(ObjectRequestSuccess)success
               failure:(ObjectRequestFailure)failure;

#pragma mark - Stakes

- (void)componentsForEvent:(EventModel *)event line:(LineModel *)line success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)coefficientForEvent:(EventModel *)event line:(LineModel *)line components:(NSArray *)components success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)setStakeForEvent:(NSNumber *)event success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

@end
