//
//  SubscriberModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 15.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface SubscriberModel : NSObject

@property (nonatomic, strong) NSNumber *subscribed;
@property (nonatomic, strong) UserModel *user;

@end
