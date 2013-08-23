//
//  Parametrization.h
//  Puntr
//
//  Created by Eugene Tulushev on 21.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Parametrization <NSObject>

- (NSDictionary *)wrappedParameters;

@optional
- (NSDictionary *)parameters;

@end
