//
//  TNIObjectManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RKObjectManager.h"
@class TNIEnter, TNIRegistration;

typedef void (^ObjectRequestSuccess)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^ObjectRequestFailure)(RKObjectRequestOperation *operation, NSError *error);

@interface TNIObjectManager : RKObjectManager

- (void)configureMapping;

#pragma mark - Authorization

- (void)enter:(TNIEnter *)enter success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - Registration

- (void)registration:(TNIRegistration *)registration success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

#pragma mark - Events

- (void)eventsForGroup:(NSString *)group limit:(NSNumber *)limit success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

- (void)eventsForGroup:(NSString *)group
                filter:(NSArray *)categoryTags
                search:(NSString *)search
                 limit:(NSNumber *)limit
                  page:(NSNumber *)page
               success:(ObjectRequestSuccess)success
               failure:(ObjectRequestFailure)failure;

@end
