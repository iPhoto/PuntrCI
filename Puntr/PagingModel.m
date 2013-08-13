//
//  PagingModel.m
//  Puntr
//
//  Created by Eugene Tulushev on 07.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PagingModel.h"

@interface PagingModel ()

@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *offset;
@property (nonatomic, strong) NSDate *beforeTimestamp;

@property (nonatomic) NSUInteger page;

@end

@implementation PagingModel

- (NSDictionary *)parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.limit) {
        [parameters setObject:self.limit forKey:KeyLimit];
    }
    if (self.offset) {
        [parameters setObject:self.offset forKey:KeyOffset];
    }
    if (self.beforeTimestamp) {
        [parameters setObject:self.beforeTimestamp forKey:KeyBeforeTimestamp];
    }
    return [parameters copy];
}

- (void)firstPage {
    self.page = 0;
    if (!self.limit) {
        self.limit = @10;
    }
    [self calculateOffset];
    self.beforeTimestamp = [NSDate date];
}

- (void)nextPage {
    self.page++;
    [self calculateOffset];
}

- (void)setDefaultLimit:(NSNumber *)limit {
    self.limit = limit;
}

- (void)calculateOffset {
    self.offset = @(self.page * self.limit.integerValue);
}

@end
