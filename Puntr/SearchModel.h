//
//  SearchModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 23.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic, strong) NSString *query;

+ (SearchModel *)searchWithQuery:(NSString *)query;

@end
