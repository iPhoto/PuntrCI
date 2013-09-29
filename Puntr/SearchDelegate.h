//
//  SearchDelegate.h
//  Puntr
//
//  Created by Eugene Tulushev on 27.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDelegate <NSObject>

- (void)cancelSearch;
- (void)hideKeyboard;
- (void)searchFor:(NSString *)query;

@end
