//
//  AwardCell.m
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AwardCell.h"

@interface AwardCell  ()

@property (nonatomic, retain) UIImageView *awardImageView;
@property (nonatomic, retain) UILabel *awardPointsCount;
@property (nonatomic, retain) UILabel *awardTitle;

@property (nonatomic, retain) UIButton *shareAward;

@end

@implementation AwardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
