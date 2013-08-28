//
//  AwardModel.h
//  Puntr
//
//  Created by Momus on 29.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwardModel : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, copy, readonly) NSURL *image;

@end
