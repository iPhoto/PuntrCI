//
//  CategoryCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryModel.h"

@implementation CategoryCell

- (void)loadWithCategory:(CategoryModel *)category {
    UIImageView *imageViewBackground = [[UIImageView alloc] initWithFrame:self.frame];
    imageViewBackground.image = [[UIImage imageNamed:@"categoryNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 1.0f, 1.0f)];
    self.backgroundView = imageViewBackground;
    
    UIImageView *imageViewSelectedBackground = [[UIImageView alloc] initWithFrame:self.frame];
    imageViewSelectedBackground.image = [[UIImage imageNamed:@"categorySelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f)];
    self.selectedBackgroundView = imageViewSelectedBackground;
}

@end
