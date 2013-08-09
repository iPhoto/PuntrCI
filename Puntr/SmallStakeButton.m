//
//  SmallStakeButton.m
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SmallStakeButton.h"

@implementation SmallStakeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"Ставить" forState:UIControlStateNormal];
        [self setAdjustsImageWhenHighlighted:NO];
    }
    return self;
}

@end
