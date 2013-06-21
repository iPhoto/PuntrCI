//
//  TNIHTTPClient.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIHTTPClient.h"
#import <RestKit/ObjectMapping/RKHTTPUtilities.h>

@interface TNIHTTPClient ()

@property (nonatomic, strong) NSString *sid;

@end

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

#pragma mark - Authorization

- (void)enterWithLogin:(NSString *)login password:(NSString *)password success:(JSONSuccess)success failure:(JSONFailure)failure {
    [self JSONWithRequestMethod:RKRequestMethodPOST path:APIAuthorization parameters:@{KeyLogin: login, KeyPassword: password} success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            self.sid = JSON[KeySID];
            success(request, response, JSON);
        }
    } failure:failure];
}

- (void)logoutWithSuccess:(JSONSuccess)success failure:(JSONFailure)failure {
    [self JSONWithRequestMethod:RKRequestMethodDELETE path:APIAuthorization parameters:@{KeySID: self.sid} success:success failure:failure];
}

#pragma mark - Registration

- (void)registerWithEmail:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname username:(NSString *)username success:(JSONSuccess)success failure:(JSONFailure)failure {
    [self JSONWithRequestMethod:RKRequestMethodPOST path:APIUsers parameters:@{KeyEmail: email, KeyPassword: password, KeyFirstName: firstname, KeyLastName: lastname, KeyUsername: username} success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            self.sid = JSON[KeySID];
            success(request, response, JSON);
        }
    } failure:failure];
}

#pragma mark - Helpers

- (void)JSONWithRequestMethod:(RKRequestMethod)requestMethod path:(NSString *)path parameters:(NSDictionary *)parameters success:(JSONSuccess)success failure:(JSONFailure)failure {
    NSMutableURLRequest *request = [self requestWithMethod:RKStringFromRequestMethod(requestMethod) path:path parameters:parameters];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

@end
