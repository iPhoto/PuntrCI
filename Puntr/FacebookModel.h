//
//  FacebookModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 16.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AccessModel.h"
#import <Foundation/Foundation.h>

@interface FacebookModel : AccessModel

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *accessToken;

@end
