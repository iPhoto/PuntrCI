//
//  LeadCellDelegate.h
//  Puntr
//
//  Created by Eugene Tulushev on 29.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LeadCellDelegate <NSObject>

@optional
- (void)reloadData;
- (void)actionOnModel:(NSObject *)model;

@end
