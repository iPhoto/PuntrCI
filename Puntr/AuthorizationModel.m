//
//  AuthorizationModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AuthorizationModel.h"

@implementation AuthorizationModel

- (NSDictionary *)parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.sid) {
        [parameters setObject:self.sid forKey:KeySID];
    }
    if (self.secret) {
        [parameters setObject:self.secret forKey:KeySecret];
    }
    return [parameters copy];
}

- (NSDictionary *)wrappedParameters {
    return @{KeyAuthorization: [self parameters]};
}

@end
