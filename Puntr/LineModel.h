//
//  LineModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ComponentModel.h"
#import <Foundation/Foundation.h>

@interface LineModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong) NSArray *components;

- (NSDictionary *)parameters;

@end
