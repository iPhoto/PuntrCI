//
//  TNIHTTPClient.h
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

typedef void (^JSONSuccess)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
typedef void (^JSONFailure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);

@interface TNIHTTPClient : AFHTTPClient

+ (TNIHTTPClient *)sharedClient;

- (void)testSuccess:(JSONSuccess)success failure:(JSONFailure)failure;
- (void)enterWithLogin:(NSString *)login password:(NSString *)password success:(JSONSuccess)success failure:(JSONFailure)failure;
- (void)registerWithEmail:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname nickname:(NSString *)nickname success:(JSONSuccess)success failure:(JSONFailure)failure;


@end
