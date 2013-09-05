//
//  CategoryModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (CategoryModel *)categoryWithTag:(NSNumber *)tag
{
    CategoryModel *category = [[self alloc] init];
    category.tag = tag;
    return category;
}

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

@end
