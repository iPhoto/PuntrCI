//
//  SectionModel.h
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *image;
@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong) UIImage *imageHardcode;

+ (GroupModel *)group;

- (NSDictionary *)parameters;

@end
