//
//  ComponentModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ComponentModel.h"

@implementation ComponentModel

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.position)
    {
        [parameters setObject:self.position forKey:KeyPosition];
    }
    if (self.selectedCriterion)
    {
        [parameters setObject:self.selectedCriterion forKey:KeySelectedCriterion];
    }
    return [parameters copy];
}

- (CriterionModel *)selectedCriterionObject
{
    for (CriterionModel *criterion in self.criteria) {
        if ([criterion.tag isEqualToNumber:self.selectedCriterion])
        {
            return criterion;
        }
    }
    return nil;
}

@end
