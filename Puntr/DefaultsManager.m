//
//  DefaultsManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "DefaultsManager.h"

static NSString * const TNDefaultCategoryTag = @"TNDefaultCategoryTag";

@interface DefaultsManager ()

@property (nonatomic) BOOL defaultCategoryTagLoaded;

@property (nonatomic, strong) NSNumber *categoryTag;

@end

@implementation DefaultsManager

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

- (NSNumber *)defaultCategoryTag
{  
    NSNumber *defaultCategoryTag = nil;
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

@end
