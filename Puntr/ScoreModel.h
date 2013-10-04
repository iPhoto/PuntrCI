//
//  ScoreModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *time;
@property (nonatomic, strong, readonly) NSNumber *participantTag;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *status;

@end
