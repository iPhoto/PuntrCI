//
//  DynamicSelectionModel.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/26/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicSelectionModel : NSObject

@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;

@end
