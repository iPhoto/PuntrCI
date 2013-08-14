//
//  CategoryCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryModel.h"

@interface CategoryCell ()

@property (nonatomic) BOOL loaded;
@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation CategoryCell

- (void)loadWithCategory:(CategoryModel *)category
{
    if (!self.loaded)
    {
        UIImageView *imageViewBackground = [[UIImageView alloc] initWithFrame:self.frame];
        imageViewBackground.image = [[UIImage imageNamed:@"categoryNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 1.0f, 1.0f)];
        self.backgroundView = imageViewBackground;
        
        UIImageView *imageViewSelectedBackground = [[UIImageView alloc] initWithFrame:self.frame];
        imageViewSelectedBackground.image = [[UIImage imageNamed:@"categorySelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f)];
        self.selectedBackgroundView = imageViewSelectedBackground;
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.bounds.size.width - 10.0f, self.bounds.size.height)];
        self.labelTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
        self.labelTitle.textColor = [UIColor whiteColor];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        self.labelTitle.shadowColor = [UIColor blackColor];
        self.labelTitle.shadowOffset = CGSizeMake(0.0f, -1.5f);
        [self addSubview:self.labelTitle];
        
        self.loaded = YES;
    }
    self.labelTitle.text = category.title;
}

- (void)prepareForReuse
{
    self.selected = NO;
}

@end
