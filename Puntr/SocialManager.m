//
//  SocialManager.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/7/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SocialManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "VKAccessToken.h"
#import "VKUser.h"

static SocialManager  *sharedManager = nil;

@interface SocialManager ()

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, retain) ACAccount *twitterAccount;
@property (nonatomic, strong) SocialManagerSuccess success;

@end

@implementation SocialManager

@synthesize delegate;

- (id) init{
    self = [super init];
    if (nil == sharedManager) {
        [SocialManager setSharedManager:self];
    }
    return self;
}

+ (void)setSharedManager:(SocialManager *)manager
{
    sharedManager = manager;
}

+ (SocialManager*)sharedManager
{
    return sharedManager;
}

- (void)loginWithSocialNetworkOfType:(SocialNetworkType)socialNetworkType success:(SocialManagerSuccess)success{
    self.success = success;
    switch (socialNetworkType) {
        case SocialNetworkTypeFacebook:
            [self loginFb];
            break;
        
        case SocialNetworkTypeTwitter:
            [self loginTw];
            break;
            
        case SocialNetworkTypeVkontakte:
            [self loginVk];
            break;
        default:
            break;
    }
}

- (void)loginFb{
    
    if(!self.accountStore)
        self.accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                               options:@{ACFacebookAppIdKey: @"203657029796954", ACFacebookPermissionsKey: @[@"email"]}
                                            completion:^(BOOL granted, NSError *error) {
                                                if(granted){
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookTypeAccount];
                                                    self.facebookAccount = [accounts lastObject];
                                                    NSLog(@"Success");
                                                    NSLog(@"acces token %@",[[self.facebookAccount credential] oauthToken]);
                                                    [self userFbData];
                                                }else{
                                                    NSLog(@"Fail");
                                                    NSLog(@"Error: %@", error);
                                                }
                                            }];
}

- (void)loginTw{
    
    [self.delegate socialManagerDelegateMethod:self];

}

- (void)loginVk{

    [[VKConnector sharedInstance] setDelegate:self];
    [[VKConnector sharedInstance] startWithAppID:@"3806903"
                                      permissons:nil];
}

- (void) VKConnector:(VKConnector *)connector accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"vk_user_id: %lu",(unsigned long)[VKUser currentUser].accessToken.userID);
    NSLog(@"vk_user_token: %@",[VKUser currentUser].accessToken.token);
    //self.success();
}

- (void)userFbData {
    
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = self.facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *fbDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dict: %@", fbDictionary);
    }];
    
}

@end
