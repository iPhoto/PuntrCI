//
//  DefaultsManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AuthorizationModel.h"
#import "DefaultsManager.h"

static NSString * const TNDefaultAuthorization = @"TNDefaultAuthorization";
static NSString * const TNDefaultCategoryTag = @"TNDefaultCategoryTag";
static NSString * const TNExcludedCategoryTags = @"TNExcludedCategoryTags";

@interface DefaultsManager ()

@property (nonatomic) NSDictionary *authorizationLoaded;
@property (nonatomic) BOOL defaultCategoryTagLoaded;
@property (nonatomic) BOOL excludedCategoryTagsLoaded;

@property (nonatomic, strong) NSNumber *categoryTag;
@property (nonatomic, copy) NSArray *categoryTags;

@end

@implementation DefaultsManager

#pragma mark - Singleton

+ (DefaultsManager *)sharedManager
{
    static DefaultsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                     {
                         sharedManager = [[self alloc] init];
                         sharedManager.isIos6 = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending);
                     }
                 );
    return sharedManager;
}

#pragma mark - Saved Authorization

- (AuthorizationModel *)authorization
{
    if (!self.authorizationLoaded)
    {
        self.authorizationLoaded = [[NSUserDefaults standardUserDefaults] objectForKey:TNDefaultAuthorization];
    }
    return [AuthorizationModel authorizationWithDictionary:self.authorizationLoaded];
}

- (void)setAuthorization:(AuthorizationModel *)authorization
{
    if (authorization)
    {
        self.authorizationLoaded = authorization.saveParameters;
        [[NSUserDefaults standardUserDefaults] setObject:self.authorizationLoaded forKey:TNDefaultAuthorization];
    }
    else
    {
        self.authorizationLoaded = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TNDefaultAuthorization];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Default Catagory Tag

- (NSNumber *)defaultCategoryTag
{  
    NSNumber *defaultCategoryTag = @0;
    if (self.defaultCategoryTagLoaded)
    {
        defaultCategoryTag = self.categoryTag;
    }
    else
    {
        self.categoryTag = defaultCategoryTag = [[NSUserDefaults standardUserDefaults] objectForKey:TNDefaultCategoryTag];
        self.defaultCategoryTagLoaded = YES;
    }
    
    if (!defaultCategoryTag)
    {
        defaultCategoryTag = @0;
    }
    
    return defaultCategoryTag;
}

- (void)setDefaultCategoryTag:(NSNumber *)defaultCategoryTag
{
    self.categoryTag = defaultCategoryTag;
    [[NSUserDefaults standardUserDefaults] setObject:defaultCategoryTag forKey:TNDefaultCategoryTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Excluded Category Tags

- (NSArray *)excludedCategoryTags
{
    NSArray *excludedCategoryTags = @[];
    if (self.excludedCategoryTagsLoaded)
    {
        excludedCategoryTags = self.categoryTags;
    }
    else
    {
        self.categoryTags = excludedCategoryTags = [[NSUserDefaults standardUserDefaults] objectForKey:TNExcludedCategoryTags];
    }
    
    if (!excludedCategoryTags)
    {
        excludedCategoryTags = @[];
    }
    
    return excludedCategoryTags;
}

- (void)setExcludedCategoryTags:(NSArray *)excludedCategoryTags
{
    self.categoryTags = excludedCategoryTags;
    [[NSUserDefaults standardUserDefaults] setObject:excludedCategoryTags forKey:TNExcludedCategoryTags];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
