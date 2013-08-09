//
//  RKObjectRequestOperation+HeaderFields.h
//  Puntr
//
//  Created by Eugene Tulushev on 08.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <RestKit/Network/RKObjectRequestOperation.h>

@interface RKObjectRequestOperation (HeaderFields)

- (NSNumber *)locationHeader;

@end
