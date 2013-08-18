//
//  LeadCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityModel, EventModel, NewsModel, StakeModel;

@interface LeadCell : UICollectionViewCell

+ (CGSize)sizeForModel:(NSObject *)model;

- (void)loadWithModel:(NSObject *)model;

@end
