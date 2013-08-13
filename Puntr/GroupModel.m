//
//  SectionModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

- (NSDictionary *)parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.title) {
        [parameters setObject:self.title forKey:KeyTitle];
    }
    if (self.image) {
        [parameters setObject:self.image forKey:KeyImage];
    }
    if (self.slug) {
        [parameters setObject:self.slug forKey:KeySlug];
    }
    return [parameters copy];
}

@end
