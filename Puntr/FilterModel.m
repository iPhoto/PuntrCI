//
//  FilterModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 07.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.categories)
    {
        NSMutableArray *categories = [NSMutableArray arrayWithCapacity:self.categories.count];
        for (CategoryModel *category in self.categories)
        {
            [categories addObject:category.parameters];
        }
        [parameters setObject:[categories copy] forKey:KeyCategories];
    }
    if (self.group)
    {
        [parameters setObject:self.group.parameters forKey:KeyGroup];
    }
    return [parameters copy];
}

@end
