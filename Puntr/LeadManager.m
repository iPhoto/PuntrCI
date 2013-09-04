//
//  LeadManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LeadManager.h"
#import "EventModel.h"
#import "EventViewController.h"

@implementation LeadManager

+ (LeadManager *)manager
{
    return [[self alloc] init];
}

- (void)actionOnModel:(id)model
{
    if ([model isMemberOfClass:[EventModel class]])
    {
        if (![self isVisible:[EventViewController class]]) {
            [[PuntrUtilities mainNavigationController] pushViewController:[[EventViewController alloc] initWithEvent:(EventModel *)model] animated:YES];
        }
    }
}

- (BOOL)isVisible:(Class)viewControllerClass
{
    return [[PuntrUtilities topController] isMemberOfClass:viewControllerClass];
}

@end
