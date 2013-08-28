//
//  NewsModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ActivityModel.h"
#import "SubscriptionModel.h"
#import <Foundation/Foundation.h>

@interface NewsModel : ActivityModel

@property (nonatomic, strong, readonly) SubscriptionModel *subscription;

@end
