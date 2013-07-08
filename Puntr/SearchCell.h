//
//  SearchCell.h
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UICollectionViewCell <UISearchBarDelegate>

- (void)loadSearchWithQuery:(NSString *)query;

@end
