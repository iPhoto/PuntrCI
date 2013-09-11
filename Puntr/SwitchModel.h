//
//  SwitchModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 10.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManagerTypes.h"
#import <Foundation/Foundation.h>

@interface SwitchModel : NSObject

@property (nonatomic, readonly) CollectionType firstType;
@property (nonatomic, copy, readonly) NSString *firstTitle;
@property (nonatomic, readonly) BOOL firstOn;

@property (nonatomic, readonly) CollectionType secondType;
@property (nonatomic, copy, readonly) NSString *secondTitle;
@property (nonatomic, readonly) BOOL secondOn;

+ (SwitchModel *)switchWithFirstType:(CollectionType)firstType
                          firstTitle:(NSString *)firstTitle
                             firstOn:(BOOL)firstON
                          secondType:(CollectionType)secondType
                         secondTitle:(NSString *)secondTitle
                            secondOn:(BOOL)secondON;


- (void)switchToFirst;
- (void)switchToSecond;

@end
