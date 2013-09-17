//
//  AwardModel.h
//  Puntr
//
//  Created by Momus on 29.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwardModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, copy) NSURL *image;
@property (nonatomic) BOOL received;

@end
