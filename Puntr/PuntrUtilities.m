//
//  PuntrUtilities.m
//  Puntr
//
//  Created by Momus on 11.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PuntrUtilities.h"

@implementation PuntrUtilities

+ (NSString *)formattedDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSString *resString = [formatter stringFromDate:date];
    resString = [NSString stringWithFormat:@"Через %@.", resString];
    
    return resString;
}

@end
