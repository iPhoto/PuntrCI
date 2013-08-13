//
//  RKRelationshipMapping+Convenience.h
//  Puntr
//
//  Created by Eugene Tulushev on 13.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <RestKit/ObjectMapping/RKRelationshipMapping.h>

@interface RKRelationshipMapping (Convenience)

+ (instancetype)relationshipMappingWithKeyPath:(NSString *)keyPath mapping:(RKMapping *)mapping;

@end
