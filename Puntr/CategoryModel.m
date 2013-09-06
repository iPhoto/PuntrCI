//
//  CategoryModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoryModel.h"
#import "DefaultsManager.h"
#import "ObjectManager.h"

@implementation CategoryModel

+ (CategoryModel *)categoryWithTag:(NSNumber *)tag
{
    CategoryModel *category = [[self alloc] init];
    category.tag = tag;
    return category;
}

+ (void)includedCategoriesWithSuccess:(IncludedCategories)success
{
    [[ObjectManager sharedManager] categoriesWithSuccess:^(NSArray *categories)
        {
            NSArray *excludedCategoryTags = [DefaultsManager sharedManager].excludedCategoryTags;
            NSMutableArray *includedCategories = [NSMutableArray arrayWithCapacity:categories.count];
            for (CategoryModel *category in categories)
            {
                if (![excludedCategoryTags containsObject:category.tag])
                {
                    [includedCategories addObject:category];
                }
            }
            success([includedCategories copy]);
        }
        failure:nil
    ];
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
