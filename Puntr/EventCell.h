//
//  EventCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 19.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventModel;

@interface EventCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *buttonStake;

- (void)loadWithEvent:(EventModel *)event;

@end
