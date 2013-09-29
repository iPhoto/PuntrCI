//
//  LeadCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 09.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeadCellDelegate.h"
#import "SearchDelegate.h"

@interface LeadCell : UICollectionViewCell <UISearchBarDelegate>

@property (nonatomic, weak) id <LeadCellDelegate> delegate;
@property (nonatomic, weak) id <SearchDelegate> searchDelegate;

+ (CGSize)sizeForModel:(id)model;

- (void)loadWithModel:(id)model;

@end
