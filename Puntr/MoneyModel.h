//
//  MoneyModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 18.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *amount;

+ (MoneyModel *)moneyWithAmount:(NSNumber *)amount;

@end
