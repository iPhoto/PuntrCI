//
//  UserSocialModel.h
//  Puntr
//
//  Created by Momus on 01.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialModel.h"

@interface UserSocialModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) NSURL *avatar;
@property (nonatomic, copy) NSString *socialType;
@property (nonatomic, strong) SocialModel *socialObject;

@end
