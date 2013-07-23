//
//  StakeRequestModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 22.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoefficientModel.h"
#import "ComponentModel.h"
#import "MoneyModel.h"

@interface StakeRequestModel : NSObject

@property (nonatomic, strong) NSNumber *line;
@property (nonatomic, strong) NSArray *components;
//@property (nonatomic, strong) CoefficientModel *coefficient;
//@property (nonatomic, strong) MoneyModel *money;

@end
