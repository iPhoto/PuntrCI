//
//  SocialModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 9/3/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialModel : NSObject

@property (nonatomic, strong) NSNumber *facebook;
@property (nonatomic, strong) NSNumber *twitter;
@property (nonatomic, strong) NSNumber *vk;

+ (SocialModel *)socialFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)parameters;

@end
