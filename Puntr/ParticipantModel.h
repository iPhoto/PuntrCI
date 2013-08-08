//
//  ParticipantsModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParticipantModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *tag;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *logo;
@property (nonatomic, strong, readonly) NSNumber *subscribersCount;

@end
