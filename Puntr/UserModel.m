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

@end
