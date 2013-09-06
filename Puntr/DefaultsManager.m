//
//  DefaultsManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "DefaultsManager.h"

static NSString * const TNDefaultCategoryTag = @"TNDefaultCategoryTag";
static NSString * const TNExcludedCategoryTags = @"TNExcludedCategoryTags";

@interface DefaultsManager ()

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
                     }
                 );
    return sharedManager;
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
