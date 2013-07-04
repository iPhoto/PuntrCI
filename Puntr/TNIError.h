//
//  TNIError.h
//  Puntr
//
//  Created by Eugene Tulushev on 21.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNIError : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, copy) NSArray *errors;

@end
