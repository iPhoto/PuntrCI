//
//  CredentialsModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AccessModel.h"
#import <Foundation/Foundation.h>

@interface CredentialsModel : AccessModel

@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *password;

@end
