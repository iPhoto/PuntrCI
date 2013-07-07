//
//  CollectionModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 20.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic, copy) NSString *q;
@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *offset;

@end
