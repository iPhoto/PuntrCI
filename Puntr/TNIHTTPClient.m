//
//  TNIHTTPClient.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIHTTPClient.h"
#import <RestKit/ObjectMapping/RKHTTPUtilities.h>

@implementation TNIHTTPClient

#pragma mark - Singleton

+ (TNIHTTPClient *)sharedClient {
    static TNIHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (id)init {
    NSURL *base = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/", APIScheme, APIHost]];
    
    self = [super initWithBaseURL:base];
    if (self) {
        // Use JSON
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        [self setParameterEncoding:AFJSONParameterEncoding];
    }
    return self;
}

- (void)testSuccess:(JSONSuccess)success failure:(JSONFailure)failure {
    NSDictionary *parameters = @{@"login": @"mozgovvert@gmail.com",
                                 @"password": @"123456"
                                 };
    
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:APIAuthorization parameters:parameters];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(request, response, JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(request, response, error, JSON);
    }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)JSONWithRequestMethod:(RKRequestMethod)requestMethod path:(NSString *)path parameters:(NSDictionary *)parameters success:(JSONSuccess)success failure:(JSONFailure)failure {
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:APIAuthorization parameters:parameters];
}

@end
