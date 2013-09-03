//
//  LeadManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LeadManager.h"

@implementation LeadManager

+ (LeadManager *)manager
{
    return [[self alloc] init];
}

- (void)actionOnModel:(NSObject *)model
{
    NSLog(@"Action on Model: %@", NSStringFromClass([model class]));
}

@end
