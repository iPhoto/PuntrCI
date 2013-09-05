//
//  DefaultsManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "DefaultsManager.h"

static NSString * const TNDefaultCategoryTag = @"TNDefaultCategoryTag";

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
    NSNumber *defaultCategoryTag = [[NSUserDefaults standardUserDefaults] objectForKey:TNDefaultCategoryTag];
    if (!defaultCategoryTag)
    {
        defaultCategoryTag = @0;
    }
    return defaultCategoryTag;
}

- (void)setDefaultCategoryTag:(NSNumber *)defaultCategoryTag
{
    [[NSUserDefaults standardUserDefaults] setObject:defaultCategoryTag forKey:TNDefaultCategoryTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
