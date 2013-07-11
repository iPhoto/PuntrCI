//
//  HeaderCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "HeaderCell.h"
#import "SectionModel.h"

@interface HeaderCell ()

@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong) UIImageView *imageViewSection;
@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation HeaderCell

- (void)loadWithSection:(SectionModel *)section {
    CGRect backgroundFrame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.imageViewBackground = [[UIImageView alloc] initWithFrame:backgroundFrame];
    self.imageViewBackground.image = [[UIImage imageNamed:@"catalogueHeaderBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 17.0f)];
    [self addSubview:self.imageViewBackground];
    
    self.imageViewSection = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.height, self.frame.size.height)];
    self.imageViewSection.image = section.image;
    self.imageViewSection.contentMode = UIViewContentModeCenter;
    [self addSubview:self.imageViewSection];
    
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.frame = CGRectMake(self.frame.size.height + 4.0f, 0.0f, self.frame.size.width -  (self.frame.size.height + 4.0f * 2.0f), self.frame.size.height);
    self.labelTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.text = section.title;
    [self addSubview:self.labelTitle];
    
}

- (void)prepareForReuse {
    [self.imageViewBackground removeFromSuperview];
    self.imageViewBackground = nil;
    [self.imageViewSection removeFromSuperview];
    self.imageViewSection = nil;
    [self.labelTitle removeFromSuperview];
    self.labelTitle = nil;
}

@end
