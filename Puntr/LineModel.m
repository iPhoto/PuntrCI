//
//  LineModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LineModel.h"

@implementation LineModel

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.tag)
    {
        [parameters setObject:self.tag forKey:KeyTag];
    }
    if (self.components)
    {
        NSMutableArray *components = [NSMutableArray arrayWithCapacity:self.components.count];
        for (ComponentModel *component in self.components)
        {
            [components addObject:component.parameters];
        }
        [parameters setObject:[components copy] forKey:KeyComponents];
    }
    return parameters;
}

@end
