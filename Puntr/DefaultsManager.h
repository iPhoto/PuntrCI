//
//  DefaultsManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 05.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsManager : NSObject

@property (nonatomic, strong) NSNumber *defaultCategoryTag;

+ (DefaultsManager *)sharedManager;

@end
