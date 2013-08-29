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
@property (nonatomic, strong) UIImageView *imageViewImage;

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
        
        self.loaded = YES;
    }
    
    if (category.image)
    {
        self.imageViewImage = [[UIImageView alloc] init];
        CGFloat TNSideCategoryImage = 20.0f;
        CGFloat paddingCenterLeft = ceilf( (CGRectGetWidth(self.frame) - TNSideCategoryImage ) / 2.0f);
        CGFloat paddingCenterTop = ceilf( (CGRectGetHeight(self.frame) - TNSideCategoryImage ) / 2.0f);
        self.imageViewImage.frame = CGRectMake(
                                                  paddingCenterLeft,
                                                  paddingCenterTop,
                                                  TNSideCategoryImage,
                                                  TNSideCategoryImage
                                              );
        [self.imageViewImage setImageWithURL:[category.image URLByAppendingSize:CGSizeMake(TNSideCategoryImage, TNSideCategoryImage)]];
        [self addSubview:self.imageViewImage];
    }
    else
    {
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, CGRectGetWidth(self.bounds) - 10.0f, CGRectGetHeight(self.bounds))];
        self.labelTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
        self.labelTitle.textColor = [UIColor whiteColor];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        self.labelTitle.shadowColor = [UIColor blackColor];
        self.labelTitle.shadowOffset = CGSizeMake(0.0f, -1.5f);
        self.labelTitle.text = category.title;
        [self addSubview:self.labelTitle];
    }
    
    
}

- (void)prepareForReuse
{
    self.selected = NO;
    [self.imageViewImage removeFromSuperview];
    self.imageViewImage = nil;
    
    [self.labelTitle removeFromSuperview];
    self.labelTitle = nil;
}

@end
