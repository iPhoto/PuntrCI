//
//  FilterModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 07.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"
#import "GroupModel.h"

@interface FilterModel : NSObject

@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, strong) GroupModel *group;

+ (FilterModel *)filter;

- (NSDictionary *)parameters;

@end
