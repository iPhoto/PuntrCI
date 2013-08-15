//
//  PasswordModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PasswordModel.h"

@implementation PasswordModel

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.password)
    {
        [parameters setObject:self.password forKey:KeyPassword];
    }
    if (self.passwordNew)
    {
        [parameters setObject:self.passwordNew forKey:KeyPasswordNew];
    }
    if (self.passwordNewConfirmation)
    {
        [parameters setObject:self.passwordNewConfirmation forKey:KeyPasswordNewConfirmation];
    }
    return [parameters copy];
}

@end
