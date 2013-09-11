//
//  SwitchModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 10.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SwitchModel.h"

@interface SwitchModel ()

@property (nonatomic) CollectionType firstType;
@property (nonatomic, copy) NSString *firstTitle;
@property (nonatomic) BOOL firstOn;

@property (nonatomic) CollectionType secondType;
@property (nonatomic, copy) NSString *secondTitle;
@property (nonatomic) BOOL secondOn;

@end

@implementation SwitchModel

+ (SwitchModel *)switchWithFirstType:(CollectionType)firstType
                          firstTitle:(NSString *)firstTitle
                             firstOn:(BOOL)firstON
                          secondType:(CollectionType)secondType
                         secondTitle:(NSString *)secondTitle
                            secondOn:(BOOL)secondON
{
    SwitchModel *switchModel = [[self alloc] init];
    
    switchModel.firstType = firstType;
    switchModel.firstTitle = firstTitle;
    switchModel.firstOn = firstON;
    
    switchModel.secondType = secondType;
    switchModel.secondTitle = secondTitle;
    switchModel.secondOn = secondON;
    
    return switchModel;
}


- (void)switchToFirst
{
    self.firstOn = YES;
    self.secondOn = NO;
}

- (void)switchToSecond
{
    self.secondOn = YES;
    self.firstOn = NO;
}

@end
