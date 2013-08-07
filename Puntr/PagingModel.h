//
//  PagingModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 07.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PagingModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *limit;
@property (nonatomic, strong, readonly) NSNumber *offset;
@property (nonatomic, strong, readonly) NSDate *beforeTimestamp;

// Helper

- (void)firstPage;
- (void)nextPage;
- (void)setDefaultLimit:(NSNumber *)limit;


@end