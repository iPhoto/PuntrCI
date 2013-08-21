//
//  ParticipantsModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ParticipantModel.h"

@implementation ParticipantModel

- (NSDictionary *)parameters
{
    if (self.tag)
    {
        return @{ KeyTag: self.tag };
    }
    else
    {
        return @{};
    }
}

- (NSDictionary *)wrappedParameters
{
    return @{KeyParticipant: self.parameters};
}

@end
