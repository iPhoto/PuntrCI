//
//  UserModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSDictionary *)parameters
{
    if (self.tag)
    {
        return @{ KeyTag: self.tag };
    }
    else
    {
        return @{};
    }
}

- (NSURL *)avatarWithSize:(CGSize)size
{
    NSString *sizeComponent = [NSString stringWithFormat:@"%ix%i", (NSInteger)size.width, (NSInteger)size.height];
    return [self.avatar URLByAppendingPathComponent:sizeComponent];
}

- (BOOL)isEqualToUser:(UserModel *)user
{
    if ([self.tag isEqualToNumber:user.tag])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
