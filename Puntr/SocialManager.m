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
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"
#import "TwitterReverseOAuthResponse.h"
#import "VKAccessToken.h"
#import "VKUser.h"

static SocialManager  *sharedManager = nil;

@interface SocialManager ()

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, strong) TWAPIManager *twitterApiManager;
@property (nonatomic, strong) NSArray *twitterAccounts;
@property (nonatomic, strong) SocialManagerSuccess success;

@end

@implementation SocialManager

@synthesize delegate;

- (id) init
{
    self = [super init];
    if (nil == sharedManager)
    {
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

- (void)loginWithSocialNetworkOfType:(SocialNetworkType)socialNetworkType success:(SocialManagerSuccess)success
{
    self.success = success;
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
            break;
    }
}

- (void)loginFb
{
    
    if(!self.accountStore)
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                               options:@{ACFacebookAppIdKey: @"203657029796954", ACFacebookPermissionsKey: @[@"email"]}
                                            completion:^(BOOL granted, NSError *error) {
                                                if(granted)
                                                {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookTypeAccount];
                                                    self.facebookAccount = [accounts lastObject];
                                                    NSLog(@"Success");
                                                    NSLog(@"acces token %@",[[self.facebookAccount credential] oauthToken]);
                                                    [self userFbData];
                                                }
                                                else
                                                {
                                                    NSLog(@"Fail");
                                                    NSLog(@"Error: %@", error);
                                                }
                                            }];
}

- (void)loginTw
{
    if(!self.accountStore)
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    /*
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error) {
        if (granted) {
            self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
            NSMutableArray *twitterAccountsNames;
            for(ACAccount *acct in self.twitterAccounts)
            {
                [twitterAccountsNames addObject:acct.username];
            }
            [self.delegate socialManager:self twitterAccounts:twitterAccountsNames];
        }
        else
        {
            NSLog(@"no access");
        }
    };
*/
    [self.accountStore requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
            NSMutableArray *twitterAccountsNames = [[NSMutableArray alloc] init];
            for(ACAccount *acct in self.twitterAccounts)
            {
                [twitterAccountsNames addObject:acct.username];
            }
            [self.delegate socialManager:self twitterAccounts:twitterAccountsNames];
        }
        else
        {
            NSLog(@"no access");
        }
    }];
}

- (void)loginTwWithUser:(NSInteger)index
{
    if(!self.twitterApiManager)
    {
        self.twitterApiManager = [[TWAPIManager alloc] init];
    }
    [self.twitterApiManager performReverseAuthForAccount:self.twitterAccounts[index] withHandler:^(NSData *responseData,NSHTTPURLResponse *response, NSError *error)
     {
        if (responseData)
        {
            NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"Reverse Auth process returned: %@", responseStr);
            
            TwitterReverseOAuthResponse *twitterUserData = [TwitterReverseOAuthResponse oauthResponseForResponseData:responseData];
            NSLog(@"tw user token: %@; token_secret: %@; name: %@; id: %@;", twitterUserData.oauth_token, twitterUserData.oauth_token_secret, twitterUserData.screen_name, twitterUserData.user_id);
            /*NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
            NSString *lined = [parts componentsJoinedByString:@"\n"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });*/
        }
        else
        {
            NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
        }
    }];
}

- (void)loginVk
{

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
