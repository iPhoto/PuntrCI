//
//  PasswordModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordModel : NSObject

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordNew;
@property (nonatomic, copy) NSString *passwordNewConfirmation;

- (NSDictionary *)parameters;

@end
