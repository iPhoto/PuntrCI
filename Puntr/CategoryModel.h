//
//  CategoryModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IncludedCategories)(NSArray *includedCategories);

@interface CategoryModel : NSObject

@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *image;

+ (CategoryModel *)categoryWithTag:(NSNumber *)tag;
+ (void)includedCategoriesWithSuccess:(IncludedCategories)success;

- (NSDictionary *)parameters;

@end
