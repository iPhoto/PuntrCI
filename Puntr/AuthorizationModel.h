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

- (NSDictionary *)parameters;
- (NSDictionary *)wrappedParameters;

@end
