//
//  SectionModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

- (NSDictionary *)parameters
{
    if (self.slug)
    {
        return @{ KeySlug: self.slug };
    }
    else
    {
        return @{};
    }
}

@end
