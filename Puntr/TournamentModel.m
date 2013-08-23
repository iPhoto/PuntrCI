//
//  TournamentModel.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/9/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentModel.h"

@implementation TournamentModel

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
    return @{KeyTournament: self.parameters};
}
@end
