//
//  PuntrUtilities.m
//  Puntr
//
//  Created by Momus on 11.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PuntrUtilities.h"
#import <FormatterKit/TTTTimeIntervalFormatter.h>

@implementation PuntrUtilities

+ (NSString *)formattedDate:(NSDate *)date
{
    TTTTimeIntervalFormatter *formatter = [[TTTTimeIntervalFormatter alloc] init];
    formatter.usesAbbreviatedCalendarUnits = YES;
    return [formatter stringForTimeIntervalFromDate:[NSDate date] toDate:date];
}

@end
