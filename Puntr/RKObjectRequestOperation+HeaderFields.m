//
//  RKObjectRequestOperation+HeaderFields.m
//  Puntr
//
//  Created by Eugene Tulushev on 08.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "RKObjectRequestOperation+HeaderFields.h"

@implementation RKObjectRequestOperation (HeaderFields)

- (NSNumber *)locationHeader {
    NSString *locationHeader = self.HTTPRequestOperation.request.allHTTPHeaderFields[@"Location"];
    if (locationHeader) {
        return @(locationHeader.integerValue);
    } else {
        return nil;
    }
}

@end
