//
//  CollectionManagerDelegate.h
//  Puntr
//
//  Created by Momus on 01.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//
#import "CollectionManagerTypes.h"

#ifndef Puntr_CollectionManagerDelegate_h
#define Puntr_CollectionManagerDelegate_h

@protocol CollectionManagerDelegate <NSObject>

@optional

- (void)collectionViewDidSelectCellWithModel:(id)model;
- (void)haveItems:(BOOL)haveItems withCollectionType:(CollectionType)collectionType;

@end


#endif
