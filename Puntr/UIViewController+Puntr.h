//
//  UIViewController+Puntr.h
//  Puntr
//
//  Created by Alexander Lebedev on 7/29/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Puntr)

- (void)addBalanceButton;
- (void)addFilterButton;
- (void)addSettingsButton;
- (void)updateBalance;
- (CGRect)frame;

@end
