//
//  TournamentViewController.m
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentViewController.h"
#import "TournamentModel.h"

#import <QuartzCore/QuartzCore.h>

@interface TournamentViewController ()

@property (nonatomic, retain) TournamentModel *tournament;

@property (nonatomic, retain) UIImageView *tournamentImageView;
@property (nonatomic, retain) UIImageView *sectionImageView;
@property (nonatomic, retain) UIImageView *imageViewDelimiter;
@property (nonatomic, retain) UIImageView *stagesCountImageView;

@property (nonatomic, retain) UILabel *sectionTitleLabel;
@property (nonatomic, retain) UILabel *tournamentNameLabel;
@property (nonatomic, retain) UILabel *tournamentStartTimeLabel;
@property (nonatomic, retain) UILabel *stagesCountLabel;

@property (nonatomic, retain) UIButton *buttonSubscribe;

@end

@implementation TournamentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.tournament.title;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGFloat screenWidth = 320.0f;
    CGFloat coverMargin = 8.0f;
    CGFloat backgroundHeight = 70.0f;
    
    UIView *backgroundCover = [[UIView alloc] initWithFrame:CGRectMake(coverMargin, coverMargin, screenWidth - coverMargin * 2.0f, backgroundHeight * 2.0f)];
    backgroundCover.backgroundColor = [UIColor whiteColor];
    backgroundCover.layer.cornerRadius = 3.75f;
    backgroundCover.layer.masksToBounds = YES;
    [self.view addSubview:backgroundCover];
    
    self.tournamentImageView = [[UIImageView alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
        {
            NSData *data = [[NSData alloc] initWithContentsOfURL:self.tournament.banner];
            if (data == nil)
            {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^
                {
                    self.tournamentImageView.image = [UIImage imageWithData:data];
                    self.tournamentImageView.frame = CGRectMake(0.0f, 0.0f, screenWidth, self.tournamentImageView.image.size.height);
                }
            );
        }
    );
    
    self.imageViewDelimiter = [[UIImageView alloc] initWithFrame:CGRectMake(coverMargin, coverMargin + CGRectGetHeight(self.tournamentImageView.frame), screenWidth - coverMargin * 2.0f, 1.0f)];
    self.imageViewDelimiter.image = [[UIImage imageNamed:@"leadDelimiter"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [backgroundCover addSubview:self.imageViewDelimiter];
    
    self.buttonSubscribe = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonSubscribe.frame = CGRectMake(coverMargin * 2.0f, coverMargin + CGRectGetHeight(self.tournamentImageView.frame) + 15.0f, (screenWidth - coverMargin * 5.0f) / 2.0f, 40.0f);
    self.buttonSubscribe.adjustsImageWhenHighlighted = NO;
    [self.buttonSubscribe setTitle:@"Подписаться" forState:UIControlStateNormal];
    self.buttonSubscribe.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    self.buttonSubscribe.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonSubscribe.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonSubscribe setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                                    forState:UIControlStateNormal];
    [backgroundCover addSubview:self.buttonSubscribe];
}

@end
