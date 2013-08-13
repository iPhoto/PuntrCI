//
//  RKRelationshipMapping+Convenience.m
//  Puntr
//
//  Created by Eugene Tulushev on 13.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RKRelationshipMapping+Convenience.h"

@implementation RKRelationshipMapping (Convenience)

+ (instancetype)relationshipMappingWithKeyPath:(NSString *)keyPath mapping:(RKMapping *)mapping
{
    return [self relationshipMappingFromKeyPath:keyPath toKeyPath:keyPath withMapping:mapping];
}

@end
