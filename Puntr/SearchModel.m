//
//  SearchModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 23.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

+ (SearchModel *)searchWithQuery:(NSString *)query
{
    SearchModel *search = [[self alloc] init];
    search.query = query;
    return search;
}

@end
