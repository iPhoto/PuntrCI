//
//  LeadCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeadCell, ActivityModel, EventModel, NewsModel, StakeModel, AwardModel;

@protocol LeadCellDelegate

- (void)reloadDataLeadCell:(LeadCell *)sender;

@end

@interface LeadCell : UICollectionViewCell

@property (nonatomic, weak) id <LeadCellDelegate> delegate;

+ (CGSize)sizeForModel:(NSObject *)model;

- (void)loadWithModel:(NSObject *)model;

@end
