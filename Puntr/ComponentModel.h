//
//  ComponentModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CriterionModel.h"

@interface ComponentModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *position;
@property (nonatomic, strong, readonly) NSArray *criteria;
@property (nonatomic, strong, readonly) NSNumber *selectedCriterion;

@end
