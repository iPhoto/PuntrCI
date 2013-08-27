//
//  NSURL+Puntr.m
//  Puntr
//
//  Created by Eugene Tulushev on 27.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "NSURL+Puntr.h"

@implementation NSURL (Puntr)

- (NSURL *)URLByAppendingSize:(CGSize)size
{
    NSString *sizeComponent = [NSString stringWithFormat:@"%ix%i", (NSInteger)size.width, (NSInteger)size.height];
    return [self URLByAppendingPathComponent:sizeComponent];
}

@end