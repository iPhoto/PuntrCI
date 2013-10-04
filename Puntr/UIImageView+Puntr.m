//
//  UIImageView+UIImageView_Puntr.m
//  Puntr
//
//  Created by Alexander Lebedev on 10/4/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UIImageView+Puntr.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Puntr)

- (void)imageWithUrl:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil completed:nil];
}

@end
