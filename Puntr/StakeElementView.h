//
//  StakeElementView.h
//  Puntr
//
//  Created by Eugene Tulushev on 19.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StakeElementView : UIView

- (void)loadWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)updateResult:(NSString *)result;

@end
