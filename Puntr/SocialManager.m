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
#import "FacebookModel.h"
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TwitterModel.h"
#import "TWSignedRequest.h"
#import "TwitterReverseOAuthResponse.h"
#import "VKAccessToken.h"
#import "VKontakteModel.h"
#import "VKUser.h"

@interface SocialManager ()

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, strong) TWAPIManager *twitterApiManager;
@property (nonatomic, strong) NSArray *twitterAccounts;
@property (nonatomic, strong) SocialManagerSuccess success;
@property (nonatomic, strong) SocialManagerFailure failure;

@end

@implementation SocialManager

@synthesize delegate;

+ (SocialManager *)sharedManager
{
    static SocialManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedManager = [[self alloc] init];
                  }
                  );
    return sharedManager;
}

- (void)loginWithSocialNetworkOfType:(SocialNetworkType)socialNetworkType success:(SocialManagerSuccess)success failure:(SocialManagerFailure)failure
{
    self.success = success;
    self.failure = failure;
    switch (socialNetworkType)
    {
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
            if(self.failure)
            {
                self.failure();
            }
            break;
    }
}

- (void)loginFb
{
    if (!self.accountStore)
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                               options:@{ ACFacebookAppIdKey: @"203657029796954", ACFacebookPermissionsKey: @[@"email"] }
                                            completion:^(BOOL granted, NSError *error)
                                            {
                                                if (granted)
                                                {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookTypeAccount];
                                                    self.facebookAccount = [accounts lastObject];
                                                    NSLog(@"Success");
                                                    NSLog(@"acces token %@", [[self.facebookAccount credential] oauthToken]);
                                                    [self userFbData];
                                                }
                                                else
                                                {
                                                    NSLog(@"Fail");
                                                    NSLog(@"Error: %@", error);
                                                    if(self.failure)
                                                    {
                                                        self.failure();
                                                    }
                                                }
                                            }
     ];
}

- (void)loginTw
{
    if (!self.accountStore)
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error)
                                            {
                                                if (granted)
                                                {
                                                    self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    NSMutableArray *twitterAccountsNames = [[NSMutableArray alloc] init];
                                                    for (ACAccount * acct in self.twitterAccounts)
                                                    {
                                                        [twitterAccountsNames addObject:acct.username];
                                                    }
                                                    [self.delegate socialManager:self twitterAccounts:twitterAccountsNames];
                                                }
                                                else
                                                {
                                                    NSLog(@"no access");
                                                    if(self.failure)
                                                    {
                                                        self.failure();
                                                    }
                                                }
                                            }
    ];
}

- (void)loginTwWithUser:(NSInteger)index
{
    if (!self.twitterApiManager)
    {
        self.twitterApiManager = [[TWAPIManager alloc] init];
    }
    [self.twitterApiManager performReverseAuthForAccount:self.twitterAccounts[index] withHandler:^(NSData *responseData, NSHTTPURLResponse *response, NSError *error)
        {
             if (responseData)
             {
                 NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                 
                 NSLog(@"Reverse Auth process returned: %@", responseStr);
                 
                 TwitterReverseOAuthResponse *twitterUserData = [TwitterReverseOAuthResponse oauthResponseForResponseData:responseData];
                 NSLog(@"tw user token: %@; token_secret: %@; name: %@; id: %@;", twitterUserData.oauth_token, twitterUserData.oauth_token_secret, twitterUserData.screen_name, twitterUserData.user_id);
                 TwitterModel *twModel = [[TwitterModel alloc]init];
                 twModel.tag = twitterUserData.user_id;
                 twModel.accessToken = twitterUserData.oauth_token;
                 twModel.secretToken = twitterUserData.oauth_token_secret;
                 if(self.success)
                 {
                     self.success(twModel);
                 }
             }
             else
             {
                 NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                 if(self.failure)
                 {
                     self.failure();
                 }
             }
        }
    ];
}

- (void)loginVk
{
    [[VKConnector sharedInstance] setDelegate:self];
    [[VKConnector sharedInstance] startWithAppID:@"3806903" permissons:@[@"offline"]];
}

- (void)VKConnector:(VKConnector *)connector accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    VKontakteModel *vkModel = [[VKontakteModel alloc]init];
    vkModel.tag = [NSString stringWithFormat:@"%lu", (unsigned long)[VKUser currentUser].accessToken.userID];
    vkModel.accessToken = [VKUser currentUser].accessToken.token;
    if(self.success)
    {
        self.success(vkModel);
    }

}

- (void)userFbData
{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = self.facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
        {
            NSDictionary *fbDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            FacebookModel *fbModel = [[FacebookModel alloc]init];
            fbModel.tag = [fbDictionary objectForKey:@"id"];
            fbModel.accessToken = [[self.facebookAccount credential] oauthToken];
            if(self.success)
            {
                self.success(fbModel);
            }
        }
    ];
}

@end
