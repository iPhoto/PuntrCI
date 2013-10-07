//
//  AuthorizationModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationModel : NSObject

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *pushToken;
@property (nonatomic, strong) NSDate *expires;

+ (AuthorizationModel *)authorizationWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)parameters;
- (NSDictionary *)wrappedParameters;
- (NSDictionary *)saveParameters;

@end
